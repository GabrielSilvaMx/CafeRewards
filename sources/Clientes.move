#[allow(lint(self_transfer))]
module caferewards::Clientes {
    
    public struct Cliente has key, store {
        id: UID,
        nombre: vector<u8>,
        email: vector<u8>,
        puntos: u64,
    }

    public fun crear_cliente(nombre: vector<u8>, email: vector<u8>, ctx: &mut TxContext) {
        let cliente = Cliente {
            id: object::new(ctx),
            nombre,
            email,
            puntos: 0,
        };
        transfer::transfer(cliente, tx_context::sender(ctx));
    }

    public fun agregar_puntos(cliente: &mut Cliente, puntos: u64) {
        cliente.puntos = cliente.puntos + puntos;
    }

    public fun obtener_puntos(cliente: &Cliente): u64 {
        cliente.puntos
    }

    public fun restar_puntos(cliente: &mut Cliente, cantidad: u64){
        assert!(cliente.puntos >= cantidad, 1);
        cliente.puntos = cliente.puntos - cantidad;
    }
}