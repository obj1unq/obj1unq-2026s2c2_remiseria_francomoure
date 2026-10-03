class Torino {
  const cantidadDePersonas = 4
  var property velocidadMaxima = 120
  var property color = "rojo"
  var property autonomia = 500
  const capacidadParaSillaDeRuedas = false
  const esRuidoso = true
  
  method esRuidoso() = esRuidoso
  
  method capacidadParaSillaDeRuedas() = capacidadParaSillaDeRuedas
  
  method cantidadDePersonas() = cantidadDePersonas
}

class Economico {
  var adaptaciones = [
    transportadorSillaRuedas,
    tanqueGasolina,
    cañoEscapeSilencioso
  ]
  const color = "beige"
  
  method color() = color
  
  method cantidadDePlazasDeAdaptaciones() = adaptaciones.sum(
    { adaptacion => adaptacion.plazaQueOcupa() }
  )
  
  method cantidadDePersonas() = 5 - self.cantidadDePlazasDeAdaptaciones()
  
  method velocidadMaxima() = adaptaciones.min(
    { adaptacion => adaptacion.velocidadMaxima() }
  )
  
  //chequeo que alguna de las adaptaciones permita llevar silla de ruedas
  method puedeLlevarSillaDeRuedas() = adaptaciones.any(
    { adaptacion => adaptacion.permiteSillaDeRuedas() }
  )
  
  method esRuidoso() = adaptaciones.any(
    { adaptacion => adaptacion.esRuidoso() }
  )
  
  method autonomiasQueAportan() = adaptaciones.sum(
    { adaptacion => adaptacion.autonomiaQueAporta() }
  )
  
  method autonomia() = 200 + self.autonomiasQueAportan()
}

object transportadorSillaRuedas {
  method plazaQueOcupa() = 1
  
  method velocidadMaxima() = 90
  
  method permiteSillaDeRuedas() = true
  
  method esRuidoso() = false
  
  method autonomiaQueAporta() = -20
}

object tanqueGasolina {
  method plazaQueOcupa() = 1
  
  method velocidadMaxima() = 80
  
  method permiteSillaDeRuedas() = false
  
  method esRuidoso() = false
  
  method autonomiaQueAporta() = 200
}

object cañoEscapeSilencioso {
  method plazaQueOcupa() = 0
  
  method velocidadMaxima() = 115
  
  method permiteSillaDeRuedas() = false
  
  method esRuidoso() = false
  
  method autonomiaQueAporta() = -10
}

object combiAdaptable {
  const color = "celeste"
  var property interior = interiorEspacioso
  var property motor = motorUrbano
  
  method color() = color
  
  method cantidadDePersonas() = interior.cantidadDePersonas()
  
  method capacidadParaSillaDeRuedas() = interior.capacidadParaSillaDeRuedas()
  
  method velocidadMaxima() = motor.velocidadMaxima()
  
  method autonomia() = motor.autonomia()
  
  method esRuidoso() = motor.esRuidoso()
}

object interiorEspacioso {
  const capacidadParaSillaDeRuedas = false
  
  method cantidadDePersonas() = 7
  
  method capacidadParaSillaDeRuedas() = capacidadParaSillaDeRuedas
}

object interiorAccesible {
  const capacidadParaSillaDeRuedas = true
  
  method cantidadDePersonas() = 5
  
  method capacidadParaSillaDeRuedas() = capacidadParaSillaDeRuedas
}

object motorDeportivo {
  const velocidadMaxima = 230
  const autonomia = 400
  const esRuidoso = true
  
  method velocidadMaxima() = velocidadMaxima
  
  method autonomia() = autonomia
  
  method esRuidoso() = esRuidoso
}

object motorUrbano {
  const velocidadMaxima = 130
  const autonomia = 1000
  const esRuidoso = false
  
  method velocidadMaxima() = velocidadMaxima
  
  method autonomia() = autonomia
  
  method esRuidoso() = esRuidoso
}

class Reserva {
  var property coloresContraindicados = []
  var property esRuidoso = false
  var property sillaDeRuedas = false
  var property cantidadDePersonas = 1
  var property distanciaMaxima = 20
  var property tiempoMaximo = 30
  
  method capacidadIgualOSuperiorA(
    vehiculo
  ) = vehiculo.cantidadDePersonas() >= self.cantidadDePersonas()
  
  method autonomiaIgualOSuperiorA(
    vehiculo
  ) = vehiculo.autonomia() >= self.distanciaMaxima()
  
  method velocidadMaximaSuperaAVelocidadPromedioEnAlMenos10Kilometros(
    vehiculo,
    distancia,
    tiempo
  ) = ((distancia / tiempo) + 10) <= vehiculo.velocidadMaxima()
  
  method colorNoContraindicado(vehiculo) = not coloresContraindicados.contains(
    vehiculo.color()
  )
  
  method cubreNecesidadDeSillaDeRuedas(vehiculo) {
    if (sillaDeRuedas) {
      return vehiculo.capacidadParaSillaDeRuedas()
    } else {
      return true
    }
  }
  
  method cubreNecesidadDeNoRuido(vehiculo) {
    if (esRuidoso) {
      return true
    } else {
      return not vehiculo.esRuidoso()
    }
  }
  
  method puedeSerCumplidaPor(vehiculo) = ((((self.capacidadIgualOSuperiorA(
    vehiculo
  ) and self.autonomiaIgualOSuperiorA(
    vehiculo
  )) and self.velocidadMaximaSuperaAVelocidadPromedioEnAlMenos10Kilometros(
    vehiculo,
    distanciaMaxima,
    tiempoMaximo
  )) and self.colorNoContraindicado(
    vehiculo
  )) and self.cubreNecesidadDeSillaDeRuedas(
    vehiculo
  )) and self.cubreNecesidadDeNoRuido(vehiculo)
}

class Sucursal {
  var flotaVehiculos = []
  var historialViajesRealizados = []
  
  method agregarVehiculo(vehiculo) {
    flotaVehiculos.add(vehiculo)
  }
  
  method quitarVehiculo(vehiculo) {
    flotaVehiculos.remove(vehiculo)
  }
  
  method vehiculosQueCumplenReserva(reserva) = flotaVehiculos.filter(
    { vehiculo => reserva.puedeSerCumplidaPor(vehiculo) }
  )
  
  method registrarViaje(reserva, vehiculo) {
    if (flotaVehiculos.contains(vehiculo) and self.vehiculosQueCumplenReserva(
        reserva
      ).contains(vehiculo)) historialViajesRealizados.add([reserva, vehiculo])
  }
  
  method reservasDeVehiculo(vehiculo) = historialViajesRealizados.filter(
    { viaje => viaje.get(1) == vehiculo }
  ).map({ viaje => viaje.get(0) })
  
  method distanciaTotalRecorridaPorVehiculo(vehiculo) {
    self.validarQueEsteEnFlota(vehiculo)
    return historialViajesRealizados.filter(
      { viaje => viaje.get(1) == vehiculo }
    ).sum({ viaje => viaje.get(0).distanciaMaxima() })
  }
  
  method validarQueEsteEnFlota(vehiculo) {
    if (not flotaVehiculos.contains(vehiculo)) self.error(
        "El vehículo no está en la flota"
      )
  }
}