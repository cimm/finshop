require "yaml/store"

class Store
  DATA_FILE = "data.yml"

  def initialize
    @store = YAML::Store.new(DATA_FILE)
  end

  def load
    @store.transaction do
      @store.fetch(:data, [])
    end
  end

  def upsert(records)
    stored_records = load
    stored_records.each do |stored_record|
      records.each do |record|
        stored_records.delete(stored_record) if record.equal?(stored_record)
      end
    end
    commit(stored_records + records)
  end

  def commit(records)
    @store.transaction do
      @store[:data] = records
      @store.commit
    end
  end

  def since(time)
    load.select do |record|
      record.updated_at > time
    end
  end
end
