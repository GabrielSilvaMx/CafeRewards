#[allow(lint(self_transfer))]
module caferewards::Recompensas {
    use caferewards::Clientes as Cliente;

    public struct Recompensa has key, store {
        id: UID,
        descripcion: vector<u8>,
        puntos_requeridos: u64,
    }

    // Estructura para la respuesta en formato json del canje
    public struct RespuestaCanje has store, drop {
        puntos: u64,
        mensaje: vector<u8>,
    }

    public fun crear_recompensa(descripcion: vector<u8>, puntos_requeridos: u64, ctx: &mut TxContext) {
        let recompensa = Recompensa {
            id: object::new(ctx),
            descripcion,
            puntos_requeridos,
        };
        transfer::transfer(recompensa, tx_context::sender(ctx));
    }

    public fun canjear_recompensa(cliente: &mut Cliente::Cliente, recompensa: &Recompensa): RespuestaCanje {        
        if (Cliente::obtener_puntos(cliente) >= recompensa.puntos_requeridos) {
            Cliente::restar_puntos(cliente, recompensa.puntos_requeridos);
            RespuestaCanje {
                puntos: Cliente::obtener_puntos(cliente),
                mensaje: b"Recompensa realizada",
            }
        } else {
            RespuestaCanje {
                puntos: Cliente::obtener_puntos(cliente),
                mensaje: b"No tienes suficientes puntos",
            }
        }
    }
}