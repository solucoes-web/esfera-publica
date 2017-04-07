desc "updating entries"
task :update_itens, [:delay] => [:environment] do |t,args|
  delay = args[:delay].to_i || 5
  logger.info "Adicionando #{Feed.count} feeds..."
  success_count = failure_count = 0
  @feeds = Array.new
  Feed.all.map do |feed|
    begin
      feed.add_items
      @feeds << feed
      success_count += 1
    rescue Exception => e
      failure_count += 1
      logger.debug e.message
    end
  end
  logger.info "#{count} feeds adicionados com sucesso e #{failure_count} falharam."

  loop
    success_count = failure_count = 0
    logger.info "Atualizando feeds em #{Time.now}"
    sleep delay.minutes
    @feeds.each do |feed|
      begin
        feed.update_items
        success_count += 1
      rescue Exception => e
        failure_count += 1
        logger.debug e.message
      end
    end
    logger.info "#{count} feeds atualizados com sucesso e #{failure_count} falharam."
  end
end
