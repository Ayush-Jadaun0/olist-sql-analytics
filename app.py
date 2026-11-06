"""Olist e-commerce analytics dashboard (reads the CSVs produced by run_queries.py)."""
from pathlib import Path

import pandas as pd
import plotly.express as px
import streamlit as st

st.set_page_config(page_title="Olist E-Commerce Analytics", layout="wide")
RESULTS = Path(__file__).parent / "results"


@st.cache_data
def load(name: str) -> pd.DataFrame:
    return pd.read_csv(RESULTS / f"{name}.csv")


st.title("Olist E-Commerce Analytics")
st.caption("SQL analysis of the Brazilian E-Commerce Public Dataset by Olist (delivered orders only).")

if not RESULTS.exists() or not any(RESULTS.glob("*.csv")):
    st.error("No results found. Run `python load_data.py` and `python run_queries.py` first.")
    st.stop()

tab1, tab2, tab3, tab4 = st.tabs(["Sales", "Customers", "Delivery & Reviews", "Sellers & Payments"])

# ---------------- Sales ----------------
with tab1:
    monthly = load("01_monthly_revenue_growth")
    monthly["year"] = monthly["month"].str[:4]
    years = sorted(monthly["year"].unique())
    chosen = st.multiselect("Year", years, default=years)
    m = monthly[monthly["year"].isin(chosen)]

    c1, c2, c3 = st.columns(3)
    c1.metric("Revenue", f"R$ {m['revenue'].sum():,.0f}")
    c2.metric("Orders", f"{m['orders'].sum():,}")
    c3.metric("Avg order value", f"R$ {m['revenue'].sum() / max(m['orders'].sum(), 1):,.2f}")

    st.plotly_chart(px.line(m, x="month", y="revenue", markers=True, title="Monthly revenue"),
                    width="stretch")
    left, right = st.columns(2)
    left.plotly_chart(px.bar(load("02_top_categories"), x="revenue", y="category", orientation="h",
                             title="Top 10 categories by revenue").update_yaxes(autorange="reversed"),
                      width="stretch")
    right.plotly_chart(px.bar(load("03_aov_by_state"), x="state", y="avg_order_value",
                              title="Average order value by state"), width="stretch")

# ---------------- Customers ----------------
with tab2:
    rep = load("04_repeat_purchase_rate").iloc[0]
    c1, c2, c3 = st.columns(3)
    c1.metric("Customers", f"{int(rep['customers']):,}")
    c2.metric("Repeat customers", f"{int(rep['repeat_customers']):,}")
    c3.metric("Repeat rate", f"{rep['repeat_rate_pct']}%")
    st.subheader("Top 10 customers by lifetime spend")
    st.dataframe(load("05_top_customers"), width="stretch", hide_index=True)

# ---------------- Delivery & reviews ----------------
with tab3:
    late = load("07_late_delivery_share").iloc[0]
    c1, c2 = st.columns(2)
    c1.metric("Delivered orders", f"{int(late['delivered_orders']):,}")
    c2.metric("Delivered late", f"{late['late_pct']}%")
    left, right = st.columns(2)
    left.plotly_chart(px.bar(load("06_delivery_time_by_state"), x="state", y="avg_delivery_days",
                             title="Average delivery time by state (days)"), width="stretch")
    right.plotly_chart(px.bar(load("08_late_vs_review_score"), x="delivery", y="avg_review_score",
                              title="Average review score: late vs on-time",
                              range_y=[0, 5]), width="stretch")

# ---------------- Sellers & payments ----------------
with tab4:
    left, right = st.columns(2)
    left.subheader("Top 10 sellers by revenue")
    left.dataframe(load("09_top_sellers"), width="stretch", hide_index=True)
    right.subheader("Lowest-rated sellers (30+ reviewed orders)")
    right.dataframe(load("10_worst_rated_sellers"), width="stretch", hide_index=True)
    left, right = st.columns(2)
    left.plotly_chart(px.pie(load("11_payment_types"), names="payment_type", values="orders",
                             title="Orders by payment type"), width="stretch")
    right.plotly_chart(px.bar(load("12_freight_vs_price"), x="freight_pct_of_price", y="category",
                              orientation="h", title="Shipping cost as % of item price"
                              ).update_yaxes(autorange="reversed"), width="stretch")
