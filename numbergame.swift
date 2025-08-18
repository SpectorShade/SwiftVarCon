let targetNum = Int.random(in: 1...100) 
var intentos = 0 
var adivinaNum: Int? = nil 

print("Adivina un numero entre 1 y 100.") 

while adivinaNum != targetNum 
{ 
 print("Escribe el numero que crees que sea: ", terminator: "") 
 if let input = readLine(), let numero = Int(input) 
 { 
  adivinaNum = numero intentos += 1 
  if numero < targetNum 
  { 
   print("El numero es mayor al tuyo") 
  } else if numero > targetNum 
    { 
     print("El numero es menor al tuyo") 
    } else 
      { 
       print("Correcto") 
       print("Te tomo \(intentos) intentos.") 
      } 
 } else 
   { 
    print("Introduce un numero que sea valido.") 
   } 
}
