import {
    BarChart,
    Tooltip,
    Legend,
    Bar,
    XAxis,
    YAxis,
    CartesianGrid
  } from "recharts";
  import React from "react";

export default function GenericGraph(props) {
    return (
      <div style={{ padding: "50px" }}>
        <h2>{props.title}</h2>
        <BarChart width={1500} height={300} data={props.data}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="HourOfCall" />
          <YAxis />
          <Tooltip />
          <Legend />
          <Bar type="monotone" dataKey="Calls" fill="#25a74b" />
        </BarChart>
      </div>
    );
  };