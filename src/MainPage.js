import { Component } from "react";
import { Switch } from "antd";
import CardSet from './components/CardSet'
import React from "react";
import axios from "axios";
import GenericGraph from "./components/GenericGraph"

 // Node server address
const server = '10.0.0.1';

class MainPage extends Component {
  constructor() {
    super();
    this.state = {
      people: [],
      refresh: false,
      workflow: "",
      dataPoints: []
    };
  }

  intervalID;

  onSwitch_toggle = () => {
    this.setState({ refresh: !this.state.refresh });
    this.updateStats();
  };

// Refreshes the user agent's card data initially and every 10 seconds if Switch component is true.
  updateStats = () => {
    axios
      .post(`${server}/getAgents`, {
        params: { workflow: this.state.workflow }
      })
      .then(response => {
        const people = response.data;
        this.setState({ people });
        if (this.state.refresh)
          this.intervalID = setTimeout(this.updateStats.bind(this), 10000);
      });
  };

  getGraphData = () => {
    axios
      .post(`${server}/getOverall`, {
        params: { workflow: this.state.workflow }
      })
      .then(response => this.setState({ dataPoints: response.data }));
  };

  componentDidMount() {
    this.updateStats();
    this.getGraphData();
  }

  componentWillUnmount() {
    clearTimeout(this.intervalID);
  }

  render() {
    return (
      <div>
        <div style={{ background: "#25a74b", padding: "25px" }}>
          <h1 style={{ color: "white" }}> Call Stats</h1>
          <p>
            <h3 style={{ color: "white" }}> Auto-Refresh</h3>
            <Switch onChange={this.onSwitch} />
          </p>
          <CardSet props={this.state.people} />
        </div>
        <div>
          <GenericGraph data={this.state.dataPoints} title={"All Time Call History"} />
        </div>
      </div>
    );
  }
}

export default MainPage;
