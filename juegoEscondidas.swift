enum RolesJuegoEscondidas{
    case contando
    case buscando_jugadores

    
    case buscando_escondite
    case escondido
    case regresando_a_base
    case encontrado
    
    case cantar_victoria
    case suspendido /// Es el caso en que el juego vuelve a su estado original de inicio.
}


protocol JugadorDeEscondidas: class{
    var rol: RolesJuegoEscondidas { get set }
    var compañeros_de_juego: [JugadorDeEscondidas] { get set }
    var nombre: String { get set }
    var lugar_actual: UbicacionFisica? { get set }
    var visibilidad: Double { get set }
    
    func actualizar() -> Bool
    
    func establecer_rol(_ rol_nuevo: RolesJuegoEscondidas) -> Bool
    
    func agregar_compañero(_ compañero_nuevo: JugadorDeEscondidas) -> Bool
}



extension JugadorDeEscondidas { /// Al parecer un protocol se instancia como un struct y no puede mutar el tipo de dato a menos que tenga modificado que aplciara a un tipo en especifico
    func establecer_rol(_ rol_nuevo: RolesJuegoEscondidas) -> Bool {
        switch(self.rol){
            case .suspendido: 
                self.rol = rol_nuevo
                return true
            
            case .cantar_victoria, .encontrado: 
                if rol_nuevo == .suspendido {
                    self.rol = rol_nuevo
                    return true
                }
                return false
                
                
            default: 
                return false
        }
        
    }
}

struct Ubicacion2Dimensiones{
    var x: Int
    var y: Int 
    
    init(_ x: Int, _ y: Int){
        self.x = x
        self.y = y
    }
    
    func distancia(a otra: Ubicacion2Dimensiones) -> Double {
        let dx = Double(self.x - otra.x)
        let dy = Double(self.y - otra.y)
        return (dx*dx + dy*dy).squareRoot()
    }
}

class UbicacionFisica{
    var nombre: String
    var lugares_cercanos: [UbicacionFisica]
    var trampas: [String] = [] //este es nuevo
    
    //init(_ nombre: String, lugares_cercanos: [UbicacionFisica]){
    init(_ nombre: String){
        self.nombre = nombre
        self.lugares_cercanos = []
    }
    
    func agregar_lugar(_ lugar: UbicacionFisica) -> Bool{
        for ubicacion in lugares_cercanos{
            if ubicacion.nombre == lugar.nombre{
                return false
            }
        }
        
        lugar.lugares_cercanos.append(self)
        self.lugares_cercanos.append(lugar)
        
        return true
    }
}

class Personaje {
    var nombre: String
    var ubicacion: UbicacionFisica?
    
    init(_ nombre: String){
        self.nombre = nombre
        self.ubicacion = nil
    }
    
    func establecer_ubicacion(_ nueva_ubicacion: UbicacionFisica) -> Bool{
        if ubicacion == nil{
            self.ubicacion = nueva_ubicacion
            return true
        }
        
        if ubicacion!.nombre == nueva_ubicacion.nombre{
            return false
        }
        
        ubicacion = nueva_ubicacion
        return true
    }
    
}

class PersonajeJugable: Personaje, JugadorDeEscondidas{
    var visibilidad: Double
    var rol: RolesJuegoEscondidas = .suspendido

    var lugar_actual: UbicacionFisica?
    
    var numero_contado: Int
    
    var compañeros_de_juego: [JugadorDeEscondidas] = []
    
    var energia: Int = 100 //parte de nuevo comportamiento
    var lugares_visitados: [String] = [] //para comportamiento nuevo tambien
    
    var turnos_invisible: Int = 0 //de objetos magicos
    var tiene_trampa: Bool = false//este tambien es para objetos magicos
    
    init(_ nombre: String, visibilidad: Double){
        self.visibilidad = visibilidad
        numero_contado = 0
        super.init(nombre)
        lugar_actual = nil
    }
    
    func actualizar() -> Bool{
        switch(rol){
            case .contando:
                self.contar_para_buscar()
            
            case .buscando_jugadores:
                self.identificar_jugadores()
                self.moverse_de_lugar()
            
            case .buscando_escondite:
                self.moverse_de_lugar()
                
                let quedarse_quieto = Int.random(in: 0...10)
                if quedarse_quieto % 5 == 0{
                    self.rol = .escondido
                }
                
            case .escondido:
                if turnos_invisible > 0 {
                    turnos_invisible -= 1
                    visibilidad = 0.0
                } else {
                    visibilidad = max(visibilidad, 0.1) // que no sea absoluta la invisibilidad
                }
                
                // % de probabilidad de que se use la trampa
                if !tiene_trampa && Int.random(in: 0...100) < 20 {
                    colocar_trampa()
                }
                
            case .cantar_victoria:
                print("TODO")// Validar que ya gano
                
            case .suspendido:
                print("YO \(nombre) he perdido")
            
            default:
                print("todo")
        }
        return false
    }
    
    func identificar_jugadores(){
        for compañero in compañeros_de_juego{
            if compañero.lugar_actual!.nombre == self.lugar_actual!.nombre{
                var probabildiad_de_omitir = Int(compañero.visibilidad * 100)
                
                 probabildiad_de_omitir += (100 - energia) / 2 //Aqui se simula cansancio y empeora la habilidad para buscar
                 
                 if lugares_visitados.contains(lugar_actual!.nombre) {
                    probabildiad_de_omitir -= 25
                } //esto sirve como memoria, es menos probable que se salte un lugar donde ha presenciado jugadores
                
                let suerte = Int.random(in: 0...100)
                
                if suerte > probabildiad_de_omitir{
                    compañero.rol = .suspendido
                    print("\(nombre) encontro a \(compañero.nombre) en \(lugar_actual!.nombre)")
                }
                
            }
        }
    }
    
    func moverse_de_lugar(){
        guard let actual = lugar_actual else { return }
        
        energia = max(0, energia - 5) //la energia baja cuando se mueve
        
         if actual.trampas.count > 0 {
            print("\(nombre) fue atrapado \(actual.nombre)! Pierde 15 de energia.")
            energia = max(0, energia - 15)
            actual.trampas.removeAll()
            return
        } //se checa por trampas y pierde energia
     
        var indice_de_nuevo_lugar = Int.random(
                in: 0..<lugar_actual!.lugares_cercanos.count
            )
            
        var nuevo_lugar = lugar_actual!.lugares_cercanos[indice_de_nuevo_lugar]
        
        let deberia_de_cambiar = Int.random(in: 0...10)
        
        if deberia_de_cambiar % 2 == 0 {
            cambiar_de_lugar_a(nuevo_lugar)
        }
    }
    
    func contar_para_buscar(){
        numero_contado += 1
        print("Soy \(nombre) y voy en el \(numero_contado)")
        
        if numero_contado > 10{
            self.rol = .buscando_jugadores
        }
    }
    
    func cambiar_de_lugar_a(_ ubicacion: UbicacionFisica) -> Bool{
        if self.lugar_actual == nil {
            self.lugar_actual = ubicacion
            return true 
        } 
        
        // if let ubi = lugar actual {}
        //if ubicacion != nil && ubicacion.nombre == lugar_actual.nombre{
        if ubicacion.nombre == self.lugar_actual!.nombre{
            return false
        }
        
        lugar_actual = ubicacion
        return true
    }
    
    func agregar_compañero(_ compañero_nuevo: JugadorDeEscondidas) -> Bool{
        if compañero_nuevo.nombre == self.nombre{
            return false
        }
        
        for compañero in compañeros_de_juego{
            if compañero.nombre == compañero_nuevo.nombre{
                return false
            }
        }
        
        compañeros_de_juego.append(compañero_nuevo)
        return true
    }
    
    func activar_invisibilidad(turnos: Int) {
        turnos_invisible = turnos
        print("\(nombre) es invisible por \(turnos) turnos")
    } // funcion para objeto magico
    
    func colocar_trampa() {
        guard let lugar = lugar_actual else { return }
        lugar.trampas.append(nombre)
        tiene_trampa = true
        print("\(nombre) puso una trampa en \(lugar.nombre)")
    } // funcion para objeto magico
}

func iniciar_juego(jugadores: [JugadorDeEscondidas]) {
    let numero_del_jugador_que_busca = Int.random(in: 0..<jugadores.count)
    var jugador_que_busca: JugadorDeEscondidas = jugadores[numero_del_jugador_que_busca]
    
    jugador_que_busca.establecer_rol(.contando)
    
    for jugador in jugadores {
        jugador_que_busca.agregar_compañero(jugador)
        
        if jugador.rol == .suspendido{
            jugador.establecer_rol(.buscando_escondite)
        }
    }

    // print("el numero del jugador es \(jugador_que_busca)")
}

let punto_de_inicio = Ubicacion2Dimensiones(1, 3)

var jugadores: [PersonajeJugable] = []

jugadores.append(PersonajeJugable("Pepito Bananas", visibilidad: 0.5))
jugadores.append(PersonajeJugable("Wally", visibilidad: 0.1))
jugadores.append(PersonajeJugable("Chuchito", visibilidad: 0.2))
jugadores.append(PersonajeJugable("Anabelle", visibilidad: 0.9))

let lobby = UbicacionFisica("Lobby")
let oficina = UbicacionFisica("Oficina")
let sala_de_estar = UbicacionFisica("Sala de estar")
let salon = UbicacionFisica("Salon")
let baños = UbicacionFisica("Baños")

// Lobby --- sala_de_estar
lobby.agregar_lugar(sala_de_estar)

// Lobby --- Salon
lobby.agregar_lugar(salon)

// Lobby --- oficina
lobby.agregar_lugar(oficina)

// sala_de_estar --- Baño
sala_de_estar.agregar_lugar(baños)

// Salon --- Baño
salon.agregar_lugar(baños)




var ubicaciones_juego: [UbicacionFisica] = []
ubicaciones_juego.append(lobby)


iniciar_juego(jugadores: jugadores)

for jugador in jugadores{
    jugador.cambiar_de_lugar_a(lobby)
}


/// Aqui tenemos la parte de auto juego
var ciclo_actual = 0

// Aqui va mi juego
while true {
    for jugador in jugadores{
        jugador.actualizar()
    }
    
    for jugador in jugadores{
        print("El rol de \(jugador.nombre) es \(jugador.rol)")
        print("Estoy en: \(jugador.lugar_actual?.nombre ?? "No se")")
        print("Mis compañeros son: \(jugador.compañeros_de_juego.count)")
        print("Energia: \(jugador.energia)") //nuevo para referir al comportamiento de fatiga
    }
    print("")
    
    //para que no se pasen todos los turnos de un solo instante.
    print("Presiona Enter para continuar...")
    _ = readLine()
    
    //estos son checks para marcar victoria
    let buscador = jugadores.first { $0.rol == .contando || $0.rol == .buscando_jugadores }
    let jugadores_restantes = jugadores.filter { $0.rol == .escondido || $0.rol == .buscando_escondite }
    
    if jugadores_restantes.isEmpty {
        print("El buscador \(buscador?.nombre ?? "N/A") atrapo a todos y ha ganado!")
        break
    }
   
   ciclo_actual += 1 
   if ciclo_actual > 25{
       print("Se acabo el tiempo.  El buscador ha perdido.")
       break
   }
}


