//Esto esta emulando el juego de peleas Dead or Alive, cuyo combate es caracterizado principalmente por un fuerte enfasis
//en su sistema de RPS (piedra, papel o tijeras), por lo que para esto basicamente es un RPS con tematica del juego para representarlo.


// Clase 1
class Personaje 
{
    var nombre: String
    
    init(nombre: String) 
    {
        self.nombre = nombre
    }
}


// Clase 2 (hereda de Personaje)
class Luchador: Personaje 
{
    let opciones = ["Golpe", "Agarre", "Llave"]
    
    func elegirAtaque() -> String 
    {
        return opciones.randomElement()!
    }
}

// Clase 3
class Escenario 
{
    var nombre: String
    var ubicacion: String
    var zonasPeligro: Bool 
    
    init(nombre: String, ubicacion: String, zonasPeligro: Bool) 
    {
        self.nombre = nombre
        self.ubicacion = ubicacion
        self.zonasPeligro = zonasPeligro
    }
    
    func escenarioIndicar() 
    {
        print("Escenario: \(nombre) - Ubicacion: \(ubicacion)")
    }
}

// Clase 4
class Ronda 
{
    var numeroRonda: Int
    
    init(numeroRonda: Int) 
    {
        self.numeroRonda = numeroRonda
    }
    
    func anuncio() 
    {
        print("Round \(numeroRonda)! Get Ready... FIGHT!")
    }
    
    // sistema RPS
    func quienGana(_ ataque1: String, _ ataque2: String) -> Int 
    {
        if ataque1 == ataque2 
        {
            return 0 // por cuestiones de simplicidad seria un empate.
        }
        
        if (ataque1 == "Golpe" && ataque2 == "Agarre") ||
           (ataque1 == "Agarre" && ataque2 == "Llave") ||
           (ataque1 == "Llave" && ataque2 == "Golpe") 
        {
            return 1 // gana p1
        } 
        else 
        {
            return 2 // gana p2
        }
    }
}

// Clase 5
class Pelea 
{
    var luchador1: Luchador
    var luchador2: Luchador
    var escenarios: [Escenario]
    
    init(luchador1: Luchador, luchador2: Luchador, escenarios: [Escenario]) 
    {
        self.luchador1 = luchador1
        self.luchador2 = luchador2
        self.escenarios = escenarios
    }
    
    func iniciarPelea() 
    {
        let escenario = escenarios.randomElement()!
        escenario.escenarioIndicar()
        
        print("Comienza la pelea entre P1 como \(luchador1.nombre) y P2 como \(luchador2.nombre)!")
        
        var victorias1 = 0
        var victorias2 = 0
        var rondaNum = 1
        
        while victorias1 < 2 && victorias2 < 2 
        {
            let ronda = Ronda(numeroRonda: rondaNum)
            ronda.anuncio()
            
            let ataque1 = luchador1.elegirAtaque()
            let ataque2 = luchador2.elegirAtaque()
            
            print("\(luchador1.nombre) usa \(ataque1)!")
            print("\(luchador2.nombre) usa \(ataque2)!")
            
            let resultado = ronda.quienGana(ataque1, ataque2)
            
            switch resultado 
            {
                case 0:
                    print("¡Empate en la ronda \(rondaNum)!")
                case 1:
                    victorias1 += 1
                    print("\(luchador1.nombre) gana la ronda \(rondaNum)!")
                case 2:
                    victorias2 += 1
                    print("\(luchador2.nombre) gana la ronda \(rondaNum)!")
                default:
                    break
            }
            
            rondaNum += 1
        }
        
        if victorias1 == 2 
        {
            print("\n \(luchador1.nombre) gana la pelea en \(escenario.nombre)!")
        } 
        else 
        {
            print("\n \(luchador2.nombre) gana la pelea en \(escenario.nombre)!")
        }
    }
}

// Ahora en accion

let ryu = Luchador(nombre: "Hayabusa")
let kas = Luchador(nombre: "Kasumi")

let escenarios = 
[
    Escenario(nombre: "Tatami", ubicacion: "Japon", zonasPeligro: false),
    Escenario(nombre: "Scramble", ubicacion: "EUA", zonasPeligro: true),
    Escenario(nombre: "Castillo de L", ubicacion: "China", zonasPeligro: false)
]

let pelea = Pelea(luchador1: ryu, luchador2: kas, escenarios: escenarios)
pelea.iniciarPelea()
