#[allow(lint(self_transfer))]
module caferewards::Transacciones {
    use caferewards::Clientes as Cliente;
    use std::string::String;

    // Define la estructura para una transacción con fecha y descripción
    public struct TransaccionTimeStamp has copy, drop, store {
        descripcion: String,
        fecha_hora: u64, // Timestamp en milisegundos
    }

    public struct Transaccion has key, store {
        id: UID,
        cliente: address,
        puntos: u64,
        historial: vector<TransaccionTimeStamp>,
    }

    /*
        Permite crear una nueva transacción que registra la cantidad de puntos 
        que se van a agregar o restar a un cliente.
    */
    public fun crear_transaccion(cliente: address, puntos: u64, ctx: &mut TxContext) {
        let transaccion = Transaccion {
            id: object::new(ctx),
            cliente,
            puntos,
            historial: vector::empty(),
        };
        transfer::transfer(transaccion, tx_context::sender(ctx));
    }

    /*
    Permite procesar la transacción y actualizar los puntos del cliente correspondiente.
    */
    public fun puntos_transaccion_cliente(transaccion: &mut Transaccion, descripcion: String, cliente: &mut Cliente::Cliente, ctx: &TxContext) {
        Cliente::agregar_puntos(cliente, transaccion.puntos);
        let timestamp = TransaccionTimeStamp {
            descripcion,
            fecha_hora: tx_context::epoch_timestamp_ms(ctx),
        };
        transaccion.historial.push_back(timestamp);
    }
}