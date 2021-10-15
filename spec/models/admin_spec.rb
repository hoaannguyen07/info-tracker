# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Admin, type: :model) do
    # pending "add some examples to (or delete) #{__FILE__}"

    subject(:test_admin) do
        described_class.new(email: 'tamu@gmail.com', full_name: 'Texas A&M', uid: '654cba321', avatar_url: 'www.example.com')
    end

    before do
        if described_class.where(email: 'csce431@gmail.com').first.nil? == true
            described_class.create!(email: 'csce431@gmail.com', full_name: 'Software Engineering', uid: '431506', avatar_url: 'www.example.com')
        end
    end

    context 'with Admin attribute(s)' do
        it 'is valid with all valid attributes with no empty fields' do
            expect(test_admin).to(be_valid)
        end

        context 'when EMAIL' do
            it 'is NOT valid without an email' do
                test_admin.email = nil
                expect(test_admin).not_to(be_valid)
            end

            it 'is NOT valid if it is not unique (exactly the same in the database)' do
                test_admin.email = 'csce431@gmail.com'
                expect(test_admin).not_to(be_valid)
            end

            it 'is NOT valid if it is not unique even if it has different cases (\'c\' = \'C\')' do
                test_admin.email = 'CSCE431@gmail.com'
                expect(test_admin).not_to(be_valid)
            end
        end

        context 'when FULL_NAME' do
            it 'is NOT valid without full name' do
                test_admin.full_name = nil
                expect(test_admin).not_to(be_valid)
            end

            it 'is valid with any input' do
                test_admin.full_name = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t '
                expect(test_admin).to(be_valid)
            end
        end

        context 'when UID' do
            it 'is valid with any input' do
                test_admin.uid = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t '
                expect(test_admin).to(be_valid)
            end
        end

        context 'when AVATAR_URL' do
            it 'is valid with any input' do
                test_admin.avatar_url = '`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:\'"zZxXcCvVbBnNmM,<.>/? \n\t '
                expect(test_admin).to(be_valid)
            end
        end
    end
end
