require "yaml/store"

class Store
  DATA_FILE = "data.yml"

  def initialize
    @store = YAML::Store.new(DATA_FILE)
  end

  def load
    @store.transaction(read_only: true) do
      @store.fetch(:data, [])
    end
  end

  def upsert(records)
    db_records = load
    records.each do |record|
      if exists?(record)
        i = db_records.index { |r| r.equal?(record) }
        db_records[i] = db_records[i].update(record)
      else
        db_records << record
      end
    end
    commit(db_records)
  end

  def commit(records)
    @store.transaction do
      @store[:data] = records
    end
  end

  def find(record)
    load.select do |db_record|
      db_record.equal?(record)
    end
  end

  def exists?(record)
    find(record).any?
  end
end
