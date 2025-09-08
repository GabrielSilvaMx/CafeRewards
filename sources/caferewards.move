/// Module: CafeRewards 
module caferewards::CafeRewards {
    use std::string::String;

    use caferewards::Clientes as Cliente;
    use caferewards::Recompensas as Recompensa;
    use caferewards::Transacciones as Transaccion;

    /*
    Genera las recompensas que ofreceCafeRewards
    Llamada a SUI:
        sui client call --package $PACKAGE_ID --module CafeRewards --function crearRecompensa --args "Café Grande" 250 --json
    */
    entry fun crearRecompensa(descripcion: vector<u8>, puntos_requeridos: u64, ctx: &mut TxContext) {
        Recompensa::crear_recompensa(descripcion, puntos_requeridos, ctx)
    }

    /*
    Registra un nuevo cliente en la cafetería CafeRewards
    Llamada a SUI:
        sui client call --package $PACKAGE_ID --module CafeRewards --function crearCliente --args "Gabriel" "gabo@mail.com" --json
    */
    entry fun crearCliente(nombre: vector<u8>, email: vector<u8>, ctx: &mut TxContext) {
        Cliente::crear_cliente(nombre, email, ctx);
    }

    /*
    Registra la fecha y hora en que se realiza la transacción
    Llamada a SUI:
        sui client call --package $PACKAGE_ID --module CafeRewards --function crearTransaccion --args 100 --json
    */
    entry fun crearTransaccion(puntos: u64, ctx: &mut TxContext) {
        Transaccion::crear_transaccion(tx_context::sender(ctx), puntos, ctx)
    }

    /*
    Añade puntos en la cuenta del cliente 
    Llamada a SUI:
        sui client call --package $PACKAGE_ID --module CafeRewards --function agregarPuntosCliente --args $CLIENTE_OBJ $TRANSACCION_OBJ "compra 2 cafes XG"  --json
    */
    entry fun agregarPuntosCliente(cliente: &mut Cliente::Cliente, transaccion: &mut Transaccion::Transaccion, descripcion: String, ctx: &TxContext) {
        Transaccion::puntos_transaccion_cliente(transaccion, descripcion, cliente, ctx)
    }

    /*
    Canjea el producto y restale sus puntos al Cliente, en caso contrario no tiene suficientes puntos para canjear
    Llamada a SUI:
         sui client call --package $PACKAGE_ID --module CafeRewards --function canjearREcompensa --args $CLIENTE_OBJ $RECOMPENSA_OBJ 
    */
    entry fun canjearRecompensa(cliente: &mut Cliente::Cliente, recompensa: &Recompensa::Recompensa) {
        Recompensa::canjear_recompensa(cliente, recompensa);
    }

}