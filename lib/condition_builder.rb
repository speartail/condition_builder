require 'json'

class ConditionBuilder
  
  DEFAULT_KIND = :and
  SUPPORTED_KINDS = [ :and, :or, :xor, :not ]

  def initialize(kind = DEFAULT_KIND)
    super()
    set_kind(kind)
    @_cond = []
    @_crit = {}
    @_join = []
    @_ordr = []
  end

  # TODO: add << as an alias for add - probably need to do some splatting to handle the parms
  # alias_method :'<<', :add
  # See README for usage.
  def add(condition, criteria, order = nil)
    crit_name = condition[/^(\w|\.)+/].gsub(/\s/, '_').to_s
    crit_sym = crit_name.to_sym
    raise ArgumentError, 'condition already exists' if @_crit.has_key?(crit_sym)
    if criteria.is_a?(Array)
      @_cond << "#{condition} (:#{crit_name})"
    else
      @_cond << "#{condition} :#{crit_name}"
    end
    @_crit[crit_sym] = criteria
    @_ordr << "#{crit_name} #{order.to_s.upcase}" if [ :asc, :desc ].include?(order)
  end

  # Add tables and fields for a simple INNER JOIN
  def add_join(left_table, left_field, right_table, right_field)
    # TODO: move the joins into a proper structure and only generate when it gets accessed
    @_join << "INNER JOIN #{right_table} ON #{left_table}.#{left_field} = #{right_table}.#{right_field}"
  end

  # Returns the condition string used for the :conditions parameter. See README for usage.
  def conditions
    @_cond.join(@join)
  end

  # Returns the criteria hash. See README for usage.
  def criteria
    @_crit
  end

  # Returns the join string used for the :joins parameter. See README for usage.
  def joins
    @_join.join(' ')
  end

  # Returns the order string used for the :order parameter. See README for usage.
  def order
    @_ordr.join(', ')
  end

  # Returns the number of valid statements
  def statements
    return valid? ? @_cond.length : 0
  end

  # Returns a string representation - normally used for debugging
  def to_s
    "conditions: #{@_cond.to_json}, criteria: #{@_crit.to_json}, ordering: #{@_ordr.to_json}"
  end

  # Returns true if it will generate usable output
  def valid?
    @_cond.length > 0 && (@_cond.length == @_crit.length)
  end

  # Gets the kind of condition
  def kind
    @kind
  end

  # Sets the kind of condition
  def kind=(value)
    set_kind(value)
  end

  private
  def set_kind(kind)
    @kind = SUPPORTED_KINDS.include?(kind) ? kind : DEFAULT_KIND
    @join = " #{@kind.to_s.upcase} "
    return nil
  end
  
end
