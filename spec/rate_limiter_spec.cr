require "./spec_helper"

describe RateLimiter do
  describe RateLimiter::Bucket do
    it "returns false on a new bucket" do
      bucket = RateLimiter::Bucket(Int32).new(0_u32, 0.seconds, 0.seconds)
      bucket.rate_limited?(0).should be_false
    end

    it "returns the remaining time when count is over the limit and time hasn't run out" do
      bucket = RateLimiter::Bucket(Int32).new(1_u32, 1.seconds, 5.seconds)
      bucket.rate_limited?(0)
      bucket.rate_limited?(0).should be_truthy
    end

    it "returns false on no rate limiting" do
      bucket = RateLimiter::Bucket(Int32).new(2_u32, 1.seconds, 0.seconds)
      bucket.rate_limited?(0)
      bucket.rate_limited?(0).should be_false
    end

    it "returns the remaining time when being delayed" do
      bucket = RateLimiter::Bucket(Int32).new(1_u32, 1.seconds, 5.seconds)
      bucket.rate_limited?(0)
      sleep 1
      bucket.rate_limited?(0).should be_truthy
    end
  end

  it "creates a new bucket" do
    limiter = RateLimiter(Int32).new
    limiter.bucket(:foo, 1_u32, 0.seconds, 0.seconds).should be_a(RateLimiter::Bucket(Int32))
  end

  it "handles rate limits" do
    limiter = RateLimiter(Int32).new
    limiter.bucket(:foo, 1_u32, 0.seconds, 0.seconds)

    limiter.rate_limited?(:foo, 0).should be_false
  end
end