require "yaml/store"

class Store
  def initialize(data_file)
    @store = YAML::Store.new(data_file+".yml")
  end

  def load
    @store.transaction(read_only: true) do
      @store.fetch(:data, [])
    end
  end

  def upsert(new_records)
    records = load
    new_records.each do |new_record|
      if exists?(new_record)
        i = records.index { |r| r.equal?(new_record) }
        records[i] = records[i].update(new_record)
      else
        records << new_record
      end
    end
    commit(records)
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
