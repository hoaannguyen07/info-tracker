# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Permission.create!(description: 'admin')
if Admin.where(email: 'matrev@tamu.edu').first.nil? == true
  Admin.create!(email: 'matrev@tamu.edu', full_name: 'Mark Trevino', uid: '117972233671837615000', avatar_url: 'https://lh3.googleusercontent.com/a/AATXAJyTPeVQNjmwW71cuYem7Msi_KpuKOD0huwG1iBB=s96-c')
end

if Admin.where(email: 'hoaannguyen07@gmail.com').first.nil? == true
  Admin.create!(email: 'hoaannguyen07@gmail.com', full_name: 'hoa nguyen', uid: '116423861261808432463', avatar_url: 'https://lh3.googleusercontent.com/a-/AOh14Gi1_Nq0U3QdPz9BM5iTF9FOvg0tBnBRblEqWVNV=s96-c')
end

if PermissionUser.where(permissions_id_id: Permission.where(description: 'admin').first.id,
                        user_id_id: Admin.where(email: 'matrev@tamu.edu').first.id
                       ).first.nil? == true

  PermissionUser.create!(permissions_id_id: Permission.where(description: 'admin').first.id,
                         user_id_id: Admin.where(email: 'matrev@tamu.edu').first.id,
                         created_by_id: Admin.where(email: 'matrev@tamu.edu').first.id,
                         updated_by_id: Admin.where(email: 'matrev@tamu.edu').first.id
                        )
end
