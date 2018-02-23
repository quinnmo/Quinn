connection: "thelook"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore: events {
  persist_for: "4 hours"
}

explore: inventory_items {}

explore: orders {
  sql_always_where: ${created_year} >= 1980;;
  join: order_items {
    relationship: one_to_many
    sql_on: ${orders.id} = ${order_items.order_id} ;;
  }
  join: inventory_items {
    relationship: one_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }
}

explore: products {
  fields: [products.id, products.item_name, products.rank, products.brand]
}

explore: users {
  join: user_data {
    relationship: many_to_one
    view_label: "users"
    sql_on: ${user_data.user_id} = ${users.id} ;;
  }
}

explore: order_items {
   join: orders {
    type: left_outer
    relationship: many_to_one
    sql_on: ${orders.id} = ${order_items.order_id} AND ${orders.status} = "complete"
    ;;
   }

   join: users {
    type: left_outer
    relationship: many_to_one
     sql_on: ${users.id} = ${orders.user_id} ;;
   }

  join: inventory_items{
    type: left_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id};;
  }

  join: products {
    type: inner
    relationship: one_to_one
    sql_on: ${products.id} = ${inventory_items.product_id};;
    }
    }
