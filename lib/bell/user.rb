module Bell
  class User < Sequel::Model
    DATA_PATH = File.join(File.dirname(__FILE__), '..', '..', 'data')

    attr_reader :name

    def data_file
      File.join(DATA_PATH, "#{name}.yml")
    end

    def exists?
      File.exists?(data_file)
    end

    def create
      FileUtils.touch(data_file)
    end
  end
end
