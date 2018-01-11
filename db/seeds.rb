# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do

    visualizador = Operator.new
    visualizador.name = "Alocador"
    visualizador.email = "alocador@casebras.com.br"
    visualizador.password = "Case1234"
    visualizador.password_confirmation = "Case1234"
    visualizador.isAdmin = false
    visualizador.isBlocked = false
    visualizador.save!

    bloqueado = Operator.new
    bloqueado.name = "Bloqueado"
    bloqueado.email = "bloqueado@casebras.com.br"
    bloqueado.password = "Case1234"
    bloqueado.password_confirmation = "Case1234"
    bloqueado.isAdmin = false
    bloqueado.isBlocked = true
    bloqueado.save!

    admin = Operator.new
    admin.name = "Administrador"
    admin.email = "admin@casebras.com.br"
    admin.password = "Case1234"
    admin.password_confirmation = "Case1234"
    admin.isAdmin = true
    admin.isBlocked = false
    admin.save!

    Placement.create! other: "Estoque", address: "Matriz", contact: "helpdesk@casebras.com.br"
    Placement.create! other: "Matriz", address: "Santos Dummont", contact: "88888888"
    Placement.create! other: "Corporate", address: "Santos Dummont", contact: "88888888"
    Placement.create! state: "CE", city: "Taubaté", other: "Padrão de vida", address: "Taubaté - CE", contact: "88888888"

    Company.create! name: "PADRÃO DE VIDA", cnpj: "41.324.369/0001-37"
    Company.create! name: "REALPADRÃO", cnpj: "06.134.625/0001-22"
    Company.create! name: "CASEBRAS CONSTRUÇÕES", cnpj: "03.942.405/0001-37"
    Company.create! name: "CASEBRAS FACTORING", cnpj: "05.909.661/0001-58"
    Company.create! name: "GEPROM", cnpj: "10.682.806/0001-60"
    Company.create! name: "GLOBO TURISMO", cnpj: "01.535.948/0001-04"
    Company.create! name: "PROSPERAR", cnpj: "13.397.961/0001-23"
    Company.create! name: "ROTA DO SOL", cnpj: "01.904.715/0001-31"
    Company.create! name: "BUCATINNI", cnpj: "05.878.522/0001-04"
    Company.create! name: "ML CONSULTORIA", cnpj: "14.914.605/0001-00"
    Company.create! name: "LOURENÇO E LOURENÇO", cnpj: "14.918.434/0001-80"
    Company.create! name: "GSPAR", cnpj: "15.349.281/0001-60"
    Company.create! name: "SMX", cnpj: "17.033.057/0001-90"
    Company.create! name: "ANCORA", cnpj: "05.500.166/0001-90"
    Company.create! name: "AMERICAN LASER", cnpj: "09.651.914/0001-97"
    Company.create! name: "J D WHITE COMBUSTÍVEIS LTDA", cnpj: "02.885.367/0001-65"
    Company.create! name: "RLGC", cnpj: "05.629.891/0001-63"
    Company.create! name: "CASEBRAS CARTÕES", cnpj: "18.387.317/0001-98"
    Company.create! name: "BITTEN TÁXI AÉREO LTDA - ME", cnpj: "04.976.738/0001-40"
    Company.create! name: "GDS COMÉRCIO DE ALIMENTOS LTDA - ME", cnpj: "21.162.369/0001-70"
    Company.create! name: "MASTERPLAN PROMOTORA DE VENDAS LTDA - ME", cnpj: "22.224.721/0001-18"
    Company.create! name: "RT SOLAR IMPORTAÇÃO, INDUSTRIA E COMERCIO LTDA", cnpj: "25.382.551/0001-98"
    Company.create! name: "FACILITY INFORMAÇÕES CADASTRAIS LTDA ME", cnpj: "23.766.895/0001-75"

    Supplier.create! name: "iByte", email: "contato@ibyte.com", phones: "9999-9999\n9999-9999"
    Supplier.create! name: "Nagem", email: "contato@nagem.com", phones: "9999-9999"
    Supplier.create! name: "CStore", email: "contato@cstore.com", phones: "9999-9999"

    StockItem.create! short_description: "Mouse"
    StockItem.create! short_description: "Teclado"
    StockItem.create! short_description: "Scanner Help"
    StockItem.create! short_description: "Pad Help"
    StockItem.create! short_description: "Pinpad Help"
    StockItem.create! short_description: "WebCam Help"
    StockItem.create! short_description: "Biometria Help"
end