view: order_items {
  sql_table_name: demo_db.order_items ;;
  label: "Order Items"

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

  dimension: returned {
    type: yesno
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: sale_price_tiers {
    type: tier
    tiers: [0, 2, 5, 10, 50, 100]
    sql: ${TABLE}.sale_price ;;
  }


  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }

  measure: returned_count {
    type: count                   #COUNT(CASE WHEN returned = 'yes' THEN 1 ELSE null END)
    drill_fields: [details*, returned_date]
    filters: {
      field: returned
      value: "yes"
    }
  }

  measure: percent_returned {     #not working--shows 100% returned?
    type: number
    sql: 100.00 * ${returned_count}/ NULLIF(${count}, 0) ;;
    value_format: "0.00"
  }

set: details {
  fields: [order_id, inventory_item_id, sale_price]
}
}
