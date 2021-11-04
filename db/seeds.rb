# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Permission.create!(description: 'admin') if Permission.where(description: 'admin').first.nil? == true

def seed_admin(email, full_name, uid, avatar_url)
  Admin.create!(email: email, full_name: full_name, uid: uid, avatar_url: avatar_url) if Admin.where(email: email).first.nil? == true
  if PermissionUser.where(permissions_id_id: Permission.where(description: 'admin').first.id,
                          user_id_id: Admin.where(email: email).first.id
                         ).first.nil? == true

    PermissionUser.create!(permissions_id_id: Permission.where(description: 'admin').first.id,
                           user_id_id: Admin.where(email: email).first.id,
                           created_by_id: Admin.where(email: email).first.id,
                           updated_by_id: Admin.where(email: email).first.id
                          )
  end
end

seed_admin('matrev@tamu.edu', 'Mark Trevino', '117972233671837615000', 'https://lh3.googleusercontent.com/a/AATXAJyTPeVQNjmwW71cuYem7Msi_KpuKOD0huwG1iBB=s96-c')
seed_admin('hoaannguyen07@gmail.com', 'hoa nguyen', '116423861261808432463', 'https://lh3.googleusercontent.com/a-/AOh14Gi1_Nq0U3QdPz9BM5iTF9FOvg0tBnBRblEqWVNV=s96-c')
seed_admin('brianshao@tamu.edu', 'Brian Shao', '108918496416922689353', 'https://lh3.googleusercontent.com/a/AATXAJwaibfLd5CxDce5m8DcVBlLbWqNJ1yFCE7-Rk80=s96-c%22')
seed_admin('latulod@tamu.edu', 'Leonardo Tulod', '103458809952587783049', 'https://lh3.googleusercontent.com/a/AATXAJxpjAGAio9MM6H2Zjkhs2CUSYNGDVaVu_4PgJVZ=s96-c')
seed_admin('ianmstephenson17@gmail.com', 'Ian Stephenson', '109075461371842403736', 'https://lh3.googleusercontent.com/a/AATXAJwBURI0d_d0Y6Vzf3fKmUt49xdSnGHAcOzAKzCd=s96-c')