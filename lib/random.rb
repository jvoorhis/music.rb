# A port/reduction of ghc's System.Random.Random.
class StdGen
  def self.seed(seed = make_seed)
    q, s1 = seed.divmod 2147483562
    s2    = q % 2147483398
    new(s1 + 1, s2 + 1)
  end
  
  def self.make_seed
    t = Time.now
    "#{t.usec}#{t.to_i}".to_i << 1
  end
  
  def initialize(s1, s2)
    @s1, @s2 = s1.to_i, s2.to_i
  end
  
  def next
    k    = @s1 / 53668
    s1_  = 40014 * (@s1 - k * 53668) - k * 12211
		s1__ = s1_ < 0 ? s1_ + 2147483563 : s1_
    
		k_   = @s2 / 52774
    s2_  = 40692 * (@s2 - k_ * 52774) - k_ * 3791
    s2__ = s2_ < 0 ? s2_ + 2147483399 : s2_
    
    z    = s1__ - s2__
    z_   = z < 1 ? z + 2147483562 : z
    
    [ z_, StdGen.new( s1__, s2__) ]
  end
  
  def split
    new_s1 = @s1 == 2147483562 ? 1 : @s1 + 1
    new_s2 = @s2 == 1 ? 2147483398 : @s2 - 1
    
    t1, t2 = self.next.last.to_a
    
    left   = StdGen.new(new_s1, t2)
    right  = StdGen.new(t1, new_s2)
    
    [left, right]
  end
  
  def to_a; [@s1, @s2] end
end

class Integer
  def self.randomr(range, rng)
    return randomr(range.end..range.begin, rng) if range.begin > range.end
    
    i_log_base = lambda do |b, i|
      i < b ? 1 : 1 + i_log_base[ b, i / b ]
    end
    
    k = range.end - range.begin + 1
    b = 2147483561
    n = i_log_base[b, k]
    
    f = lambda do |x, acc, g|
      if x.zero?
        [acc, g]
      else
        x, g1 = g.next
        f[n-1, x + acc * b, g1]
      end
    end
    
    v, rng1 = f[n, 1, rng]
    [range.begin + v % k, rng1]
  end
end

class Fixnum
  unless defined?(BOUNDS)
    N_BYTES = [42].pack('i').size
    N_BITS  = N_BYTES * 8
    MAX     = 2 ** (N_BITS - 2) - 1
    MIN     = -MAX - 1
    BOUNDS  = MIN..MAX
  end
end
