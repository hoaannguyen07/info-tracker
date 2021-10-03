# location: spec/models/player_spec.rb

# if don't have /config/packs-test/ folder, then need to install it
# Run the following commands:
#   rails webpacker:install
#   RAILS_ENV=test bundle exec rails webpacker:compile


require 'rails_helper'

RSpec.describe Player, type: :model do
  before(:all) do
    if (Admin.where(email: "123@gmail.com").first.nil? == true)
      Admin.create(email: "123@gmail.com", full_name: "Hello World", uid: "123abc456", avatar_url: "www.example.com")
    end
  end

  subject do
    described_class.new(admin_id: Admin.where(email: "123@gmail.com").first.id, name: "Test123", played: 0, wins: 0, strengths: "HELLO", weaknesses: "WORLD", additional_info: "!!!")
  end

  context 'Player attribute(s)' do
    it 'is valid with all valid attributes with no empty fields' do
      expect(subject).to be_valid
    end

    # TESTING ADMIN FIELD
    context 'ADMIN_ID' do
      it "is NOT valid without an admin_id" do
        subject.admin_id = nil
        expect(subject).not_to be_valid
      end

      it "is NOT valid if admin_id doesn't exist in the Admins table" do
        # an id larger than the largest id currently in the Admin table guarentees that it doesn't exist in the Admin table
        subject.admin_id = Admin.order('id ASC').first.id + 1
        expect(subject).not_to be_valid
      end

      it 'is valid if admin_id exists in the Admins table' do
        subject.admin_id = Admin.all.first.id
        expect(subject).to be_valid
      end
    end 

    # TESTING NAME FIELD
    context 'NAME' do
      it "is NOT valid without a name" do
        subject.name = nil

        expect(subject).not_to be_valid
      end

      it "is NOT valid with special characters except for spaces, '-', and '_'" do
        # Invalids
        subject.name = 'fjdkslfj@'
        expect(subject).not_to be_valid

        subject.name = 'fjdkslfj='
        expect(subject).not_to be_valid

        subject.name = 'fjdk)slfj'
        expect(subject).not_to be_valid

        subject.name = 'fjdks(lfj'
        expect(subject).not_to be_valid

        subject.name = 'fjdk[slfj'
        expect(subject).not_to be_valid

        subject.name = 'fjdk]slfj'
        expect(subject).not_to be_valid

        subject.name = 'fjdkslf{j'
        expect(subject).not_to be_valid

        subject.name = 'fjd}kslfj sdf'
        expect(subject).not_to be_valid

        subject.name = 'fjdk[slfj'
        expect(subject).not_to be_valid

        subject.name = '`fjdkslfj'
        expect(subject).not_to be_valid

        subject.name = 'fj~dkslfj'
        expect(subject).not_to be_valid

        subject.name = '!fjdkslfj'
        expect(subject).not_to be_valid

        subject.name = 'fjd@kslfj'
        expect(subject).not_to be_valid

        subject.name = 'fjdk#slfj'
        expect(subject).not_to be_valid

        subject.name = 'fjdks$lfj'
        expect(subject).not_to be_valid

        subject.name = 'fjdks%lfj'
        expect(subject).not_to be_valid

        subject.name = 'fjdks^lfj'
        expect(subject).not_to be_valid

        subject.name = '&'
        expect(subject).not_to be_valid

        subject.name = 'fjdkslfj *'
        expect(subject).not_to be_valid

        subject.name = '< fjdkslfj '
        expect(subject).not_to be_valid

        subject.name = '> >fjdkslfj '
        expect(subject).not_to be_valid

        subject.name = 'fjd,kslfj '
        expect(subject).not_to be_valid

        subject.name = 'fjdksl.fj '
        expect(subject).not_to be_valid

        subject.name = 'fjdkslfj ???'
        expect(subject).not_to be_valid

        subject.name = 'fjdksl/fj fdsfa'
        expect(subject).not_to be_valid

        subject.name = '\ \fjdkslfj '
        expect(subject).not_to be_valid

        subject.name = 'fjdkslfj |||'
        expect(subject).not_to be_valid

        subject.name = 'fjd+kslfj +'
        expect(subject).not_to be_valid

        subject.name = '=fjdk=slfj='
        expect(subject).not_to be_valid

        # Valids
        subject.name = 'fjdkslfj-fsdlkfj'
        expect(subject).to be_valid

        subject.name = '___fjdkslfjf__sdl-kfj---'
        expect(subject).to be_valid
      end
    end 

    # TESTING PLAYED FIELD
    context 'PLAYED' do
      it "is NOT valid without a 'played' input" do
        subject.played = nil

        expect(subject).not_to be_valid
      end

      it "is NOT valid with a non-numeric value" do
        subject.played = 'hello world'
        expect(subject).not_to be_valid

        subject.played = 'csce'
        expect(subject).not_to be_valid

        subject.played = 'test123'
        expect(subject).not_to be_valid

        subject.played = '123test'
        expect(subject).not_to be_valid

        subject.played = 'happy4958test'
        expect(subject).not_to be_valid

        subject.played = '12.593sdfs'
        expect(subject).not_to be_valid

        subject.played = '34.sad34'
        expect(subject).not_to be_valid
      end

      it "is NOT valid with a float" do
        subject.played = '140.2304'
        expect(subject).not_to be_valid

        subject.played = '-140.2304'
        expect(subject).not_to be_valid

        subject.played = '--140.2304'
        expect(subject).not_to be_valid
      end

      it "is NOT valid with a negative integer" do
        subject.played = '-12432'
        expect(subject).not_to be_valid

        subject.played = '---12432'
        expect(subject).not_to be_valid
      end

      it "is NOT valid with a positive, just out of bounds of an integer in [0, 2,147,483,647] from below" do
        subject.played = '-1' 
        expect(subject).not_to be_valid
      end

      # max in int SQL is 2147483647
      it "is NOT valid with a positive, just out of bounds of an integer in [0, 2,147,483,647] from above" do
        subject.played = '2147483648'
        expect(subject).not_to be_valid
      end
      
      it "is valid with a positive integer in [0, 2,147,483,647]" do
        subject.played = '+251234234' 
        expect(subject).to be_valid
      end

      it "is valid with a positive integer in [0, 2,147,483,647] on the lower edge (0)" do
        subject.played = '0' 
        expect(subject).to be_valid
      end

      # max in int SQL is 2147483647
      it "is valid with a positive integer in [0, 2,147,483,647] on the upper edge (2147483647)" do
        subject.played = '2147483647'
        expect(subject).to be_valid
      end
    end

    # TESTING WINS FIELD
    context 'WINS' do
      it "is NOT valid without a 'wins' input" do
        # make sure that play >= wins to make sure that doesn't play in roll in this test failing or succeeding
        # only test the functionality described
        subject.played = 1000000 

        subject.wins = nil
        expect(subject).not_to be_valid
      end

      it "is NOT valid with a non-numeric value" do
        subject.played = 1000000 

        subject.wins = 'hello world'
        expect(subject).not_to be_valid

        subject.wins = 'csce'
        expect(subject).not_to be_valid
        
        subject.wins = 'test123'
        expect(subject).not_to be_valid

        subject.wins = '123test'
        expect(subject).not_to be_valid

        subject.wins = 'happy4958test'
        expect(subject).not_to be_valid

        subject.wins = '12.593sdfs'
        expect(subject).not_to be_valid

        subject.wins = '34.sad34'
        expect(subject).not_to be_valid
      end

      it "is NOT valid with a float" do
        subject.played = 1000000 

        subject.wins = '140.2304'
        expect(subject).not_to be_valid

        subject.wins = '-140.2304'
        expect(subject).not_to be_valid

        subject.wins = '--140.2304'
        expect(subject).not_to be_valid
      end

      it "is NOT valid with a negative integer" do
        subject.played = 1000000 

        subject.wins = '-12432'
        expect(subject).not_to be_valid

        subject.wins = '---12432'
        expect(subject).not_to be_valid
      end

      it "is NOT valid with a positive, just out of bounds of an integer in [0, 2,147,483,647] from below" do
        subject.played = 1000000 

        subject.wins = '-1' 
        expect(subject).not_to be_valid
      end

      # max in int SQL is 2147483647
      it "is NOT valid with a positive, just out of bounds of an integer in [0, 2,147,483,647] from above" do
        subject.played = 1000000 

        subject.wins = '2147483648'
        expect(subject).not_to be_valid
      end
      
      it "is valid with a positive integer in [0, 2,147,483,647]" do
        subject.played = 2147483647 

        subject.wins = '+251234234' 
        expect(subject).to be_valid
      end

      it "is valid with a positive integer in [0, 2,147,483,647] on the lower edge (0)" do
        subject.played = 1000000 

        subject.wins = '0' 
        expect(subject).to be_valid
      end

      # max in int SQL is 2147483647
      it "is valid with a positive integer in [0, 2,147,483,647] on the upper edge (2147483647)" do
        subject.played = 2147483647 

        subject.wins = '2147483647'
        expect(subject).to be_valid
      end
    end

    context 'comparing PLAYED and WINS' do
      it "is NOT valid when value for played is less than value for wins" do
        subject.played = 1
        subject.wins = 3
        expect(subject).not_to be_valid
      end

      it "is valid when value for played is equal to value for wins" do
        subject.played = 5
        subject.wins = 5
        expect(subject).to be_valid
      end

      it "is valid when value for played is greater than value for wins" do
        subject.played = 6
        subject.wins = 5
        expect(subject).to be_valid
      end
    end

    context 'STRENGTHS' do
      it "is valid with no strength input" do
        subject.strengths = nil
        expect(subject).to be_valid
      end

      it "is valid with any input" do
        # includes all characters, including newline, tab, and spaces
        subject.strengths = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t ' 
        expect(subject).to be_valid
      end
    end

    context 'WEAKNESSES' do
      it "is valid with no strength input" do
        subject.weaknesses = nil
        expect(subject).to be_valid
      end

      it "is valid with any input" do
        # includes all characters, including newline, tab, and spaces
        subject.weaknesses = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t ' 
        expect(subject).to be_valid
      end
    end

    context 'ADDITIONAL_INFO' do
      it "is valid with no strength input" do
        subject.additional_info = nil
        expect(subject).to be_valid
      end

      it "is valid with any input" do
        # includes all characters, including newline, tab, and spaces
        subject.additional_info = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t ' 
        expect(subject).to be_valid
      end
    end
  end
end
