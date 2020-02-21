import { Card, Col, Row, Statistic } from "antd";
import React from "react";

export default function CardSet(props) {
  return <ListCards people={props.people} />;
}

// Maps the list of agents (users that have received a call today) as individual cards
const ListCards = props => (
  <Row gutter={16}>
    {props.people.map((person, index) => (
      <Col span={4} offset={!index && 1}>
        {renderCard(person)}
      </Col>
    ))}
  </Row>
);

const renderCard = ({ AgentName, CallsTaken, TotalCallTime, Ext }) => {
  return (
    <Card
      title={
        <div>
          <p> {AgentName}</p> {Ext}
        </div>
      }
      bordered={false}
      style={{ margin: "10px" }}
      bodyStyle={{ background: "#fff" }}
      headStyle={{ background: "#e4b73e", color: "white" }}
    >
      <Statistic title="Calls Taken Today" value={CallsTaken} />
      <Statistic title="Total Call Time" value={niceTime(TotalCallTime)} />
    </Card>
  );
};

// Nice little function that display the time in a readable format of 00h 00m 00s
const niceTime = time => {
  var hrs = ~~(time / 3600);
  var mins = ~~((time % 3600) / 60);
  var secs = ~~time % 60;
  var ret = "";
  if (hrs > 0) ret += "" + hrs + "h " + (mins < 10 ? "0" : "");
  ret += "" + mins + "m " + (secs < 10 ? "0" : "");
  ret += "" + secs + "s ";
  return ret;
};
