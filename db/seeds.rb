#Users
admin_role = Role.create!(name: 'brewmaster_yoda', display_name: 'Master Yoda')
user_role = Role.create!(name: 'brewmaster_jedi', display_name: 'Obi wan Kenobi')
guest_role = Role.create!(name: 'brewmaster_padawan', display_name: 'Luke Skywalker')

#Roles
master_brewmaster =     User.create!(name: 'ray_daniels',
                                     email: 'ray@daniels.com',
                                     password: 'master_brewmaster',
                                     password_confirmation: 'master_brewmaster')

brewmaster =            User.create!(name: 'john_palmer',
                                     email: 'john@palmer.com',
                                     password: 'brewmaster',
                                     password_confirmation: 'brewmaster')

apprentice_brewmaster = User.create!(name: 'buskic',
                                     email: 'boris@huskic.rs',
                                     password: 'wannabebrewer',
                                     password_confirmation: 'wannabebrewer')
#Role permissions
Role.all.each do |role|
  %w(UserPolicy RecipePolicy GroceryPolicy RolePolicy).each do |policy|
    case role
    when user_role
      if policy == "UserPolicy"
        scoped_actions = %w(show? update?)
        actions = %w(show? update?)
      else
        scoped_actions = %w(update? destroy?)
        actions = %w(index? show? create? update? destroy?)
      end
    when guest_role
      scoped_actions = %w(show? update?)
      if policy == "UserPolicy"
        actions = %w(show? update?)
      else
        actions = %w(show?)
      end
    else
      scoped_actions = []
      actions = %w(index? show? create? update? destroy?)
    end
    unless %w(RolePolicy GroceryPolicy).include?(policy) && role != admin_role
      actions.each do |action|
        policy_scope = "owner?" if scoped_actions.include?(action)
        FactoryGirl.create(:role_permission,
                           role: role,
                           name: action,
                           policy_name: policy,
                           policy_scope: policy_scope)
      end
    end
  end
end
#Roles to user
master_brewmaster.roles << admin_role
brewmaster.roles << user_role

#Groceries
pale_ale_malt = Grocery.create!(name: 'Pale Ale', grocery_type: 'Malt', characteristics: '.....')
amarillo_hops = Grocery.create!(name: 'Amarillo', grocery_type: 'Hops', characteristics: '.....')
yeast         = Grocery.create!(name: 'Wyeast American ale', grocery_type: 'Yeast', characteristics: '.....')

#Recipes
brewmaster_recipe = Recipe.create!(name: 'InhALE',
                                   beer_type: 'Ale',
                                   beer_style: 'American Pale Ale',
                                   procedure_description: '.......'  )

#Recipe ingredients
malt = Ingredient.create!(grocery_id: pale_ale_malt.id, recipe_id: brewmaster_recipe.id, amount: '5,2 kg')
hops = Ingredient.create!(grocery_id: amarillo_hops.id, recipe_id: brewmaster_recipe.id, amount: '45 g')
yeast = Ingredient.create!(grocery_id: yeast.id, recipe_id: brewmaster_recipe.id, amount: '2 liter starter')
