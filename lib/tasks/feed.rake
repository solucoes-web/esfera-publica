desc "adding entries"
task add_itens: :environment do
  Feed.all.each do |feed|
    Rake::Task["update_itens"].invoke feed.add_itens
  end
end

desc "updating entries"
task :update_itens, [:feed] => [:environment] do |t, args|
  loop
    sleep 5.minutes
    Feed.all.each do |feed|
      feed.update_entries args[:feed]
    end
  end
end
