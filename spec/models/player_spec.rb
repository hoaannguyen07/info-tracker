# frozen_string_literal: true

# location: spec/models/player_spec.rb

# if don't have /config/packs-test/ folder, then need to install it
# Run the following commands:
#   rails webpacker:install
#   RAILS_ENV=test bundle exec rails webpacker:compile

require 'rails_helper'

RSpec.describe(Player, type: :model) do
  subject(:test_player) do
    if Admin.where(email: '123@gmail.com').first.nil? == true
      Admin.create!(email: '123@gmail.com', full_name: 'Hello World', uid: '123abc456', avatar_url: 'www.example.com')
    end
    described_class.new(admin_id: Admin.where(email: '123@gmail.com').first.id, name: 'Test123', played: 0, wins: 0, strengths: 'HELLO', weaknesses: 'WORLD', additional_info: '!!!')
  end

  context 'with Player attribute(s)' do
    it 'is valid with all valid attributes with no empty fields' do
      expect(test_player).to(be_valid)
    end

    # TESTING ADMIN FIELD
    context 'when ADMIN_ID' do
      it 'is NOT valid without an admin_id' do
        test_player.admin_id = nil
        expect(test_player).not_to(be_valid)
      end

      it "is NOT valid if admin_id doesn't exist in the Admins table" do
        # an id larger than the largest id currently in the Admin table guarentees that it doesn't exist in the Admin table
        test_player.admin_id = Admin.order('id ASC').first.id + 1
        expect(test_player).not_to(be_valid)
      end

      it 'is valid if admin_id exists in the Admins table' do
        test_player.admin_id = Admin.all.first.id
        expect(test_player).to(be_valid)
      end
    end

    # TESTING NAME FIELD
    context 'when NAME' do
      it 'is NOT valid without a name' do
        test_player.name = nil

        expect(test_player).not_to(be_valid)
      end

      it "is NOT valid with special characters except for spaces, '-', and '_'" do
        # Invalids
        test_player.name = 'fjdkslfj@'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdkslfj='
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdk)slfj'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdks(lfj'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdk[slfj'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdk]slfj'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdkslf{j'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjd}kslfj sdf'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdk[slfj'
        expect(test_player).not_to(be_valid)

        test_player.name = '`fjdkslfj'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fj~dkslfj'
        expect(test_player).not_to(be_valid)

        test_player.name = '!fjdkslfj'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjd@kslfj'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdk#slfj'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdks$lfj'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdks%lfj'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdks^lfj'
        expect(test_player).not_to(be_valid)

        test_player.name = '&'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdkslfj *'
        expect(test_player).not_to(be_valid)

        test_player.name = '< fjdkslfj '
        expect(test_player).not_to(be_valid)

        test_player.name = '> >fjdkslfj '
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjd,kslfj '
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdksl.fj '
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdkslfj ???'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdksl/fj fdsfa'
        expect(test_player).not_to(be_valid)

        test_player.name = '\ \fjdkslfj '
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjdkslfj |||'
        expect(test_player).not_to(be_valid)

        test_player.name = 'fjd+kslfj +'
        expect(test_player).not_to(be_valid)

        test_player.name = '=fjdk=slfj='
        expect(test_player).not_to(be_valid)

        # Valids
        test_player.name = 'fjdkslfj-fsdlkfj'
        expect(test_player).to(be_valid)

        test_player.name = '___fjdkslfjf__sdl-kfj---'
        expect(test_player).to(be_valid)
      end
    end

    # TESTING PLAYED FIELD
    context 'when PLAYED' do
      it "is NOT valid without a 'played' input" do
        test_player.played = nil

        expect(test_player).not_to(be_valid)
      end

      it 'is NOT valid with a non-numeric value' do
        test_player.played = 'hello world'
        expect(test_player).not_to(be_valid)

        test_player.played = 'csce'
        expect(test_player).not_to(be_valid)

        test_player.played = 'test123'
        expect(test_player).not_to(be_valid)

        test_player.played = '123test'
        expect(test_player).not_to(be_valid)

        test_player.played = 'happy4958test'
        expect(test_player).not_to(be_valid)

        test_player.played = '12.593sdfs'
        expect(test_player).not_to(be_valid)

        test_player.played = '34.sad34'
        expect(test_player).not_to(be_valid)
      end

      it 'is NOT valid with a float' do
        test_player.played = '140.2304'
        expect(test_player).not_to(be_valid)

        test_player.played = '-140.2304'
        expect(test_player).not_to(be_valid)

        test_player.played = '--140.2304'
        expect(test_player).not_to(be_valid)
      end

      it 'is NOT valid with a negative integer' do
        test_player.played = '-12432'
        expect(test_player).not_to(be_valid)

        test_player.played = '---12432'
        expect(test_player).not_to(be_valid)
      end

      it 'is NOT valid with a positive, just out of bounds of an integer in [0, 2,147,483,647] from below' do
        test_player.played = '-1'
        expect(test_player).not_to(be_valid)
      end

      # max in int SQL is 2147483647
      it 'is NOT valid with a positive, just out of bounds of an integer in [0, 2,147,483,647] from above' do
        test_player.played = '2147483648'
        expect(test_player).not_to(be_valid)
      end

      it 'is valid with a positive integer in [0, 2,147,483,647]' do
        test_player.played = '+251234234'
        expect(test_player).to(be_valid)
      end

      it 'is valid with a positive integer in [0, 2,147,483,647] on the lower edge (0)' do
        test_player.played = '0'
        expect(test_player).to(be_valid)
      end

      # max in int SQL is 2147483647
      it 'is valid with a positive integer in [0, 2,147,483,647] on the upper edge (2147483647)' do
        test_player.played = '2147483647'
        expect(test_player).to(be_valid)
      end
    end

    # TESTING WINS FIELD
    context 'when WINS' do
      it "is NOT valid without a 'wins' input" do
        # make sure that play >= wins to make sure that doesn't play in roll in this test failing or succeeding
        # only test the functionality described
        test_player.played = 1_000_000

        test_player.wins = nil
        expect(test_player).not_to(be_valid)
      end

      it 'is NOT valid with a non-numeric value' do
        test_player.played = 1_000_000

        test_player.wins = 'hello world'
        expect(test_player).not_to(be_valid)

        test_player.wins = 'csce'
        expect(test_player).not_to(be_valid)

        test_player.wins = 'test123'
        expect(test_player).not_to(be_valid)

        test_player.wins = '123test'
        expect(test_player).not_to(be_valid)

        test_player.wins = 'happy4958test'
        expect(test_player).not_to(be_valid)

        test_player.wins = '12.593sdfs'
        expect(test_player).not_to(be_valid)

        test_player.wins = '34.sad34'
        expect(test_player).not_to(be_valid)
      end

      it 'is NOT valid with a float' do
        test_player.played = 1_000_000

        test_player.wins = '140.2304'
        expect(test_player).not_to(be_valid)

        test_player.wins = '-140.2304'
        expect(test_player).not_to(be_valid)

        test_player.wins = '--140.2304'
        expect(test_player).not_to(be_valid)
      end

      it 'is NOT valid with a negative integer' do
        test_player.played = 1_000_000

        test_player.wins = '-12432'
        expect(test_player).not_to(be_valid)

        test_player.wins = '---12432'
        expect(test_player).not_to(be_valid)
      end

      it 'is NOT valid with a positive, just out of bounds of an integer in [0, 2,147,483,647] from below' do
        test_player.played = 1_000_000

        test_player.wins = '-1'
        expect(test_player).not_to(be_valid)
      end

      # max in int SQL is 2147483647
      it 'is NOT valid with a positive, just out of bounds of an integer in [0, 2,147,483,647] from above' do
        test_player.played = 1_000_000

        test_player.wins = '2147483648'
        expect(test_player).not_to(be_valid)
      end

      it 'is valid with a positive integer in [0, 2,147,483,647]' do
        test_player.played = 2_147_483_647

        test_player.wins = '+251234234'
        expect(test_player).to(be_valid)
      end

      it 'is valid with a positive integer in [0, 2,147,483,647] on the lower edge (0)' do
        test_player.played = 1_000_000

        test_player.wins = '0'
        expect(test_player).to(be_valid)
      end

      # max in int SQL is 2147483647
      it 'is valid with a positive integer in [0, 2,147,483,647] on the upper edge (2147483647)' do
        test_player.played = 2_147_483_647

        test_player.wins = '2147483647'
        expect(test_player).to(be_valid)
      end
    end

    context 'when comparing PLAYED and WINS' do
      it 'is NOT valid when value for played is less than value for wins' do
        test_player.played = 1
        test_player.wins = 3
        expect(test_player).not_to(be_valid)
      end

      it 'is valid when value for played is equal to value for wins' do
        test_player.played = 5
        test_player.wins = 5
        expect(test_player).to(be_valid)
      end

      it 'is valid when value for played is greater than value for wins' do
        test_player.played = 6
        test_player.wins = 5
        expect(test_player).to(be_valid)
      end
    end

    context 'when STRENGTHS' do
      it 'is valid with no strength input' do
        test_player.strengths = nil
        expect(test_player).to(be_valid)
      end

      it 'is valid with any input' do
        # includes all characters, including newline, tab, and spaces
        test_player.strengths = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t '
        expect(test_player).to(be_valid)
      end
    end

    context 'when WEAKNESSES' do
      it 'is valid with no strength input' do
        test_player.weaknesses = nil
        expect(test_player).to(be_valid)
      end

      it 'is valid with any input' do
        # includes all characters, including newline, tab, and spaces
        test_player.weaknesses = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t '
        expect(test_player).to(be_valid)
      end
    end

    context 'when ADDITIONAL_INFO' do
      it 'is valid with no strength input' do
        test_player.additional_info = nil
        expect(test_player).to(be_valid)
      end

      it 'is valid with any input' do
        # includes all characters, including newline, tab, and spaces
        test_player.additional_info = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t '
        expect(test_player).to(be_valid)
      end
    end
  end
end
