let objNum = Int.random(in: 1...100) 
var intentos = 0 
var adivinaNum: Int? = nil 

print("Adivina un numero entre 1 y 100.") 

while adivinaNum != objNum 
{
    print("Escribe el numero que crees que sea: ", terminator: "") 
    
    if let entrada = readLine(), var numero = Int(entrada) 
    {
        if numero < 1 || numero > 100 
        {
            print("Introduce un numero valido (entre 1 y 100).")
            continue
        }
        
        adivinaNum = numero 
        intentos += 1 
        
        if numero < objNum 
        {
            print("El numero es mayor al tuyo")
        } 
        else if numero > objNum 
        {
            print("El numero es menor al tuyo")
        } 
        else 
        {
            print("Correcto") 
            print("Te tomo \(intentos) intentos.") 
        }
    } 
    else 
    { 
        print("Numero invalido.")
        print("Introduce un numero que sea valido (entre 1 y 100).") 
    }
}

