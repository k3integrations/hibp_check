require 'spec_helper'

RSpec.describe HibpCheck do
  let(:client) { HibpCheck.new }

  context 'initializing' do
    let(:client) { HibpCheck.new(open_timeout: 5) }

    it 'sets the params' do
      expect( client.params ).to eql( {open_timeout: 5} )
    end
  end

  context 'password_used' do
    it 'with nil' do
      expect( client.password_used(nil) ).to eq nil
    end

    it 'with a found password' do
      VCR.use_cassette "sekrit1" do
        expect( client.password_used('sekrit1') ).to eq 33
        expect( client.prefix ).to eq '0D692'
        expect( client.remainder ).to eq 'A79100891F44823116D5064A21BAB85643F'
        expect( client.hashes.include? 'A79100891F44823116D5064A21BAB85643F:33' ).to be true
        expect( client.request ).to be_an_instance_of(Net::HTTP::Get)
        expect( client.response ).to be_an_instance_of(Net::HTTPOK)
      end
    end

    it 'with a not-found password' do
      VCR.use_cassette "not_found" do
        expect( client.password_used('..some.thing123.unknown.xyz') ).to eq 0
      end
    end
  end

  context 'sha1_used' do
    it 'with nil' do
      expect( client.sha1_used(nil) ).to eq nil
    end

    it 'with an invalid sha1 string' do
      expect( client.sha1_used('blah') ).to eq nil
    end

    it 'with a found sha1 hash - for: sekrit1' do
      VCR.use_cassette "sekrit1" do
        expect( client.sha1_used('0d692a79100891f44823116d5064a21bab85643f') ).to eq 33
        expect( client.prefix ).to eq '0D692'
        expect( client.remainder ).to eq 'A79100891F44823116D5064A21BAB85643F'
        expect( client.hashes.include? 'A79100891F44823116D5064A21BAB85643F:33' ).to be true
        expect( client.request ).to be_an_instance_of(Net::HTTP::Get)
        expect( client.response ).to be_an_instance_of(Net::HTTPOK)
      end
    end

    it 'with an upcase found sha1 hash - for: sekrit1' do
      VCR.use_cassette "sekrit1" do
        expect( client.sha1_used('0D692A79100891F44823116D5064A21BAB85643F') ).to eq 33
      end
    end

    it 'with a not-found sha1 hash - for: ..some.thing123.unknown.xyz' do
      VCR.use_cassette "not_found" do
        expect( client.sha1_used('055d0c055178f3ccc1ca1b4192b4e19ffb7ba785') ).to eq 0
      end
    end
  end
end
