desc "updating entries"
task :update_items, [:delay] => [:environment] do |t,args|
  delay = args[:delay] || 5
  loop do
    itens_count = Item.count
    success_count = failure_count = 0
    start_time = Time.now
    puts "Atualizando feeds em #{start_time}"
    Feed.all.each do |feed|
      begin
        feed.update_items
        success_count += 1
      rescue Exception => e
        failure_count += 1
        puts feed.name
        puts e.message
      end
    end
    puts "#{success_count} feeds atualizados com sucesso e #{failure_count} falharam."
    itens_count = Item.count - itens_count
    puts "#{itens_count} novos itens processados em #{(Time.now - start_time).round(0)} segundos"
    sleep delay.to_i.minutes
  end
end
