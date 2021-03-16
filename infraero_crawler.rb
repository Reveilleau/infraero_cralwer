require 'nokogiri'
#require 'httparty'

#Devido a dificuldades que tive com o cookie, adaptei o crawler para funcionar com arquivos HTML locais.
#Pretendo resolver isso futuramente...

puts ('===='*10) + 'INFRAERO AEROPORTOS' + ('===='*10)
puts 'VOOS DO AEROPORTO DE CURITIBA DIGITE: 1'
puts 'VOOS DO AEROPORTO DE NAVEGANTES DIGITE: 2'
puts 'VOOS DO AEROPORTO DE CONGONHAS - SP DIGITE: 3'
puts 'INSIRA O CODIGO DESEJADO:'
cod_aero = gets.to_i
if cod_aero == 1
    aero = 'SBCT.html'
elsif cod_aero == 2
    aero = 'SBNF.html'
elsif cod_aero == 3
    aero = 'SBSP.html'
else
    puts = 'CODIGO INVALIDO'
end

#response = HTTParty.post('http://voos.infraero.gov.br/voos/index_2.aspx', 
    #:headers => {
        #"Cookie": "_ga=GA1.3.1325983921.1615379808; ASP.NET_SessionId=vuanbd45oo5uqjvwxkdiuu45; __utmc=144647858; _gid=GA1.3.141222003.1615591394; __utmz=144647858.1615750224.5.4.utmcsr=www4.infraero.gov.br|utmccn=(referral)|utmcmd=referral|utmcct=/; __utma=144647858.1325983921.1615379808.1615808178.1615815589.8; __utmt=1; __utmb=144647858.4.10.1615815589"
        
        #},
        #:body => {                      
        #    "dpl_aeroporto": cod_icao, 
        #}.to_json
#)
#doc = Nokogiri::HTML(response)

doc = Nokogiri::HTML(File.read(aero))  


Table_voos = doc.css('td') #buscar a tag td

dados_voo = []
coleta_completa = false

open("#{aero}.csv", 'w') do |arquivo| #criar arquivo .csv
    arquivo.puts('"OPERADORA","NUMERO DO VOO","DESTINO","DATA", "HORARIO PREVISTO", "HORARIO CONFIRMADO","STATUS"')
Table_voos.search('span').each do |span| #buscar a tag span dentro da tag td
    next if span['id'] == nil
    
    if span['id'].include?("nom_cia") 
        cia_aerea = span.text
        dados_voo.push(cia_aerea)
    
    elsif span['id'].include?("num_voo") 
        num_voo = span.text
        dados_voo.push(num_voo)

    elsif span['id'].include?("nom_localidade") 
        destino = span.text
        dados_voo.push(destino)

    elsif span['id'].include?("dat_voo") 
        data = span.text
        dados_voo.push(data)

    elsif span['id'].include?("hor_prev") 
        horario_previsto = span.text
        dados_voo.push(horario_previsto)

    elsif span['id'].include?("HOR_CONF")
        horario_confirmado = span.text
        dados_voo.push(horario_confirmado)

    elsif span['id'].include?("DSC_STATUS")
        status = span.text
        dados_voo.push(status)
        coleta_completa = true
        

    end
    
    if coleta_completa == true
        
        arquivo.puts "\"#{dados_voo[0]}\",\"#{dados_voo[1]}\",\"#{dados_voo[2]}\,\"#{dados_voo[3]}\",\"#{dados_voo[4]}\",\"#{dados_voo[5]}\",\"#{dados_voo[6]}\""
        coleta_completa = false
        dados_voo = []
    end     

    

end
    puts ('===='*10) + "ARQUIVO CSV CRIADO COM SUCESSO!" + ('===='*10)
end
