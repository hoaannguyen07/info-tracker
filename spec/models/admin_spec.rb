require 'rails_helper'

RSpec.describe Admin, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  before do
    if (Admin.where(email: "csce431@gmail.com").first.nil? == true)
      Admin.create(email: "csce431@gmail.com", full_name: "Software Engineering", uid: "431506", avatar_url: "www.example.com")
    end
  end

  subject do
    described_class.new(email: "tamu@gmail.com", full_name: "Texas A&M", uid: "654cba321", avatar_url: "www.example.com")
  end

  context 'Admin attribute(s)' do
    it 'is valid with all valid attributes with no empty fields' do
      expect(subject).to be_valid
    end

    context 'EMAIL' do
      it 'is NOT valid without an email' do
        subject.email = nil
        expect(subject).not_to be_valid
      end
      
      it 'is NOT valid if it is not unique (exactly the same in the database)' do
        subject.email = "csce431@gmail.com"
        expect(subject).not_to be_valid
      end

      it 'is NOT valid if it is not unique even if it has different cases (\'c\' = \'C\')' do
        subject.email = "CSCE431@gmail.com"
        expect(subject).not_to be_valid
      end
    end

    context 'FULL_NAME' do
      it 'is NOT valid without full name' do
        subject.full_name = nil
        expect(subject).not_to be_valid
      end

      it 'is valid with any input' do
        subject.full_name = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t '
        expect(subject).to be_valid
      end
    end

    context 'UID' do
      it 'is valid with any input' do
        subject.uid = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t '
        expect(subject).to be_valid
      end
    end

    context 'AVATAR_URL' do
      it 'is valid with any input' do
        subject.avatar_url = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t '
        expect(subject).to be_valid
      end
    end
  end
end
