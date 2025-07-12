#!/usr/bin/env ruby

# Test database connection script
# Run this to verify your Render PostgreSQL database connection

require 'pg'

puts "Testing Render PostgreSQL Database Connection..."
puts "=" * 50

# Database configuration
config = {
  host: 'dpg-d1ouuo7fte5s73bot940-a',
  port: 5432,
  dbname: 'voting_platform_db',
  user: 'voting_platform_db_user',
  password: 'UDcpBe2x8uXAXiXIdalEZXCzKinuLQz3'
}

begin
  puts "Attempting to connect to database..."
  conn = PG.connect(config)
  
  puts "✅ Successfully connected to database!"
  
  # Test a simple query
  result = conn.exec('SELECT version()')
  puts "PostgreSQL Version: #{result[0]['version']}"
  
  # Test if our tables exist
  result = conn.exec("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")
  
  if result.any?
    puts "Tables found:"
    result.each do |row|
      puts "  - #{row['table_name']}"
    end
  else
    puts "No tables found (this is normal for a new database)"
  end
  
  conn.close
  puts "✅ Database connection test completed successfully!"
  
rescue PG::ConnectionBad => e
  puts "❌ Database connection failed: #{e.message}"
  puts "Please check:"
  puts "  - Database host is correct"
  puts "  - Database credentials are correct"
  puts "  - Database is running and accessible"
  exit 1
  
rescue => e
  puts "❌ Unexpected error: #{e.message}"
  exit 1
end 