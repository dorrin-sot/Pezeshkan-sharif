import './page.css'
const appointments_list = [{id: 1,Doctor: "Ahmadi", Date: "2024/05/01", Location: "Tehran/Azadi/Daneshgah e Sharif"}, {id: 2, Doctor: "Rajabi", Date: "2024/03/11", Location: "Tehran/Azadi/Daneshgah e Sharif"}]
function App(props) {
    console.log("myprops:", props)
    return <li className={'nav-items2'}> Date: { props.date }, Doctor: {props.doctor}, Location: {props.location}</li>;
  }
export function Appointments ({ props }) {
    const state = props
    console.log(state)
    console.log("here")
    return (
        <>
          <h1>Welcome {state.username} </h1>
          <ul>
            {appointments_list.map((app) => <App key={app.id} date={app.Date} doctor={app.Doctor} location={app.Location} />)}
          </ul>
        </>
      );
}