# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Image, type: :model) do
  subject(:test_img) do
    described_class.new(caption: 'This is a test caption', img: fixture_file_upload('good.png', 'image/png'))
  end

  context 'with Image attribute(s)' do
    it 'is valid with valid png and filled in caption' do
      expect(test_img).to(be_valid)
    end

    it 'is valid with valid jpg and filled in caption' do
      test_img.img = fixture_file_upload('computer.jpg', 'image/jpg')
      expect(test_img).to(be_valid)
    end

    it 'is valid with valid jpeg and filled in caption' do
      test_img.img = fixture_file_upload('flower.jpeg', 'image/jpeg')
      expect(test_img).to(be_valid)
    end

    it 'is invalid with an invalid file type pdf and a valid caption' do
      test_img.img = fixture_file_upload('bad.pdf', 'text/pdf')
      expect(test_img).not_to(be_valid)
    end

    it 'is invalid with a valid file type and missing caption' do
      test_img.caption = nil
      expect(test_img).not_to(be_valid)
    end

    it 'is invalid with valid file type and too long of a caption' do
      test_img.caption = 'a' * 257
      expect(test_img).not_to(be_valid)
    end

    it 'is invalid with invalid file type and missing caption' do
      test_img.img = fixture_file_upload('bad.pdf', 'text/pdf')
      test_img.caption = nil
      expect(test_img).not_to(be_valid)
    end

    it 'is invalid with invalid file type and too long of a caption' do
      test_img.img = fixture_file_upload('bad.pdf', 'text/pdf')
      test_img.caption = 'a' * 257
      expect(test_img).not_to(be_valid)
    end

    it 'is invalid with missing image and valid caption' do
      test_img.img = nil
      expect(test_img).not_to(be_valid)
    end

    it 'is invalid with missing image and too long of caption' do
      test_img.img = nil
      test_img.caption = 'a' * 257
      expect(test_img).not_to(be_valid)
    end

    it 'is invalid with missing image and missing caption' do
      test_img.img = nil
      test_img.caption = nil
      expect(test_img).not_to(be_valid)
    end
  end
end
