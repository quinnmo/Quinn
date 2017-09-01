view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }

  measure: total_revenue {
    type:  sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${sale_price} ;;
    drill_fields: [details*]
  }

  measure: revenue_per_order {      ##total_revenue_per_order
    type: number
    sql: ${total_revenue}/${orders.count} ;;
    drill_fields: [details*]
  }

  measure: average_revenue_per_order {
    type: average
    sql:  ;;
  }

set: details {
  fields: [order_id, inventory_item_id, sale_price]
}

}
