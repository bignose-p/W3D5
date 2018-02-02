require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.


class SQLObject
  def self.columns
    if @columns
      @columns 
    else 
    names = 
    DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM 
      #{self.table_name}
    SQL
    
    @columns = names.first.map(&:to_sym)
  end 
  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column) do 
        self.attributes[column]
      end 
      define_method("#{column}=") do |columnset|
        self.attributes[column] = columnset
      end 
    end 
  end

  def self.table_name=(table_name)
    @table_name = table_name 
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all    
    results = 
    DBConnection.execute(<<-SQL)
        SELECT
          #{self.table_name}.*
        FROM 
        #{self.table_name}
      SQL
    self.parse_all(results)
  end

  def self.parse_all(results)
    parsed = []
    results.each do |result|
       parsed << self.new(result) 
    end 
  parsed 
  end

  def self.find(id)
    butt = 
    DBConnection.execute(<<-SQL, id)
        SELECT
          #{self.table_name}.*
        FROM 
        #{self.table_name}
        WHERE
        #{self.table_name}.id = ?
      SQL
      if butt == []
        return nil 
      else 
        self.new(butt)
      end 
  end

  def initialize(params = {})
    params.each do |key, value|
      unless self.class.columns.include?(key.to_sym)
        raise "unknown attribute '#{key}'"
      end 
      
      self.send("#{key}=", value)
    end 
  
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
