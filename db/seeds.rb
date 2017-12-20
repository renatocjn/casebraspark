# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do

    allocador = Operator.new
    allocador.name = "Alocador"
    allocador.email = "alocador@casebras.com.br"
    allocador.password = "case123"
    allocador.password_confirmation = "case123"
    allocador.canBuy = false
    allocador.canAlocate = true
    allocador.isAdmin = false
    allocador.isBlocked = false
    allocador.save!

    comprador = Operator.new
    comprador.name = "Comprador"
    comprador.email = "comprador@casebras.com.br"
    comprador.password = "case123"
    comprador.password_confirmation = "case123"
    comprador.canBuy = true
    comprador.canAlocate = false
    comprador.isAdmin = false
    comprador.isBlocked = false
    comprador.save!

    bloqueado = Operator.new
    bloqueado.name = "Bloqueado"
    bloqueado.email = "bloqueado@casebras.com.br"
    bloqueado.password = "case123"
    bloqueado.password_confirmation = "case123"
    bloqueado.canBuy = false
    bloqueado.canAlocate = false
    bloqueado.isAdmin = false
    bloqueado.isBlocked = true
    bloqueado.save!

    admin = Operator.new
    admin.name = "Admin"
    admin.email = "admin@casebras.com.br"
    admin.password = "case123"
    admin.password_confirmation = "case123"
    admin.canBuy = false
    admin.canAlocate = false
    admin.isAdmin = true
    admin.isBlocked = false
    admin.save!

    Placement.create! other: "Estoque", address: "Matriz", contact: "helpdesk@casebras.com.br"
    Placement.create! other: "Matriz", address: "Santos Dummont", contact: "88888888"
    Placement.create! other: "Corporate", address: "Santos Dummont", contact: "88888888"
    Placement.create! state: "CE", city: "Taubaté", other: "Padrão de vida", address: "Taubaté - CE", contact: "88888888"

    Company.create! name: "CASEBRAS", cnpj: "00.000.000/0000-00"
    Company.create! name: "CASPEB", cnpj: "00.000.000/0000-00"

    Supplier.create! name: "iByte", email: "ibyte@ibyte.com", phones: "9999-9999\n9999-9999"
    Supplier.create! name: "Nagem", email: "nagem@nagem.com", phones: "9999-9999"
    Supplier.create! name: "cstore", email: "cstore@cstore.com", phones: "9999-9999"

    StockItemsType.create! description: "Teclado"
    StockItemsType.create! description: "Mouse"
    StockItemsType.create! description: "Câmera"

    #ItemType.new(name: "Monitor").save!
    #ItemType.new(name: "Gabinete").save!
    #ItemType.new(name: "Impressora").save!

end