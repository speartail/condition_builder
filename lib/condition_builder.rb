class ConditionBuilder
  
  DEFAULT_KIND = :and
  SUPPORTED_KINDS = [ :and, :or, :xor, :not ]

  def initialize(kind = DEFAULT_KIND)
    super()
    set_kind(kind)
    @_cond = []
    @_crit = {}
    @_join = []
  end

  def add(condition, criteria)
    crit_name = condition[/^(\w|\.)+/].gsub(/\s/, '_').to_sym
    raise ArgumentError, 'condition already exists' if @_crit.has_key?(crit_name)
    @_cond << "#{condition} :#{crit_name.to_s}"
    @_crit[crit_name] = criteria
  end

  # TODO: add << as an alias for add - probably need to do some splatting to handle the parms
  # alias_method :'<<', :add

  def add_join(left_table, left_field, right_table, right_field)
    # TODO: move the joins into a proper structure and only generate when it gets accessed
    @_join << "INNER JOIN #{right_table} ON #{left_table}.#{left_field} = #{right_table}.#{right_field}"
  end

  def conditions
    @_cond.join(@join)
  end

  def criteria
    @_crit
  end

  def joins
    @_join.join(' ')
  end

  def statements
    return valid? ? @_cond.length : 0
  end

  def to_s
    "conditions: #{self.conditions.to_json}, criteria: #{self.criteria.to_json}"
  end

  def valid?
    @_cond.length > 0 && (@_cond.length == @_crit.length)
  end
  
  def kind
    @kind
  end

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
