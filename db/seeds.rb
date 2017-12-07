# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do

    fullAdmin = Operator.new
    fullAdmin.name = "Renato"
    fullAdmin.email = "rcjn@casebras.com.br"
    fullAdmin.password = "1234"
    fullAdmin.password_confirmation = "1234"
    fullAdmin.canBuy = true
    fullAdmin.canAlocate = true
    fullAdmin.isAdmin = true
    fullAdmin.isBlocked = false
    fullAdmin.save!

    allocador = Operator.new
    allocador.name = "Alocador"
    allocador.email = "alocador@casebras.com.br"
    allocador.password = "1234"
    allocador.password_confirmation = "1234"
    allocador.canBuy = false
    allocador.canAlocate = true
    allocador.isAdmin = false
    allocador.isBlocked = false
    allocador.save!

    comprador = Operator.new
    comprador.name = "Comprador"
    comprador.email = "comprador@casebras.com.br"
    comprador.password = "1234"
    comprador.password_confirmation = "1234"
    comprador.canBuy = true
    comprador.canAlocate = false
    comprador.isAdmin = false
    comprador.isBlocked = false
    comprador.save!

    bloqueado = Operator.new
    bloqueado.name = "Bloqueado"
    bloqueado.email = "bloqueado@casebras.com.br"
    bloqueado.password = "1234"
    bloqueado.password_confirmation = "1234"
    bloqueado.canBuy = false
    bloqueado.canAlocate = false
    bloqueado.isAdmin = false
    bloqueado.isBlocked = true
    bloqueado.save!

    admin = Operator.new
    admin.name = "Admin"
    admin.email = "admin@casebras.com.br"
    admin.password = "1234"
    admin.password_confirmation = "1234"
    admin.canBuy = false
    admin.canAlocate = false
    admin.isAdmin = true
    admin.isBlocked = false
    admin.save!

    Placement.new(other: "Matriz", address: "Santos Dummont", contact: "88888888").save!
    Placement.new(other: "Corporate", address: "Santos Dummont", contact: "88888888").save!
    Placement.new(state: "CE", city: "Taubaté", other: "Padrão de vida", address: "Taubaté - CE", contact: "88888888").save!

    #ItemType.new(name: "Monitor").save!
    #ItemType.new(name: "Gabinete").save!
    #ItemType.new(name: "Impressora").save!

end