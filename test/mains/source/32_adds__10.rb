class Integer < Data4
  def <(right)
    X.comparison(:<)
  end
  def +(right)
    X.int_operator(:+)
  end
  def -(right)
    X.int_operator(:-)
  end
end
class Space
  def main(arg)
    a = 0
    b = 20
    while( a < b )
      a = a + 1
      b = b - 1
    end
    return a
  end
end
