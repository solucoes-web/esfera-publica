Stopwords = Dir["#{Rails.root}/config/stopwords/*"].map do |dic|
  YAML.load_file dic
end
