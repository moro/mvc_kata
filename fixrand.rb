Kernel.module_eval do
  alias __rand__ rand
  def rand(v)
    (v < 1) ? __rand__(v) : 1
  end
end
