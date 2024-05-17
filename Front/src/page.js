import { useState } from 'react'
import './page.css'
import { Appointments } from './appointments'
export function Page ({ props }) {
    const state = props
    const [appointmentsClicked, setAppointmentsClicked] = useState(false)
    const [profileClicked, setProfileClicked] = useState(false)
    const [makeReservationClicked, setMakeReservationClicked] = useState(false)

    console.log(state)

    const onAppontmentsClick = (event) => {
        console.log("Appontments clicked!")
        if(!appointmentsClicked){
            setAppointmentsClicked(true)
        }
        event.stopPropagation();
      }
    if(state.data == 'Patient'){
        if(!appointmentsClicked && !profileClicked && !makeReservationClicked){
            return(
                // <div>Welcome {state.username}!</div>
                // 
                <div className="mainContainer">
                    <div className={'titleContainer'}>
                        <div>Welcome {state.username}!</div>
                    </div>
                    {/*  */}
                    {/* <div class="btn-group">
    <button>Apple</button>
    <button>Sony</button>
    </div> */}
                    {/*  */}
                    <div className='menu-container'>
                        <div>
                            <input
                            className={'nav-items'}
                            type="button"
                            onClick={props}
                            value={ 'Profile'}
                            />
                        </div>
                        <div>
                            <input
                            className={'nav-items'}
                            type="button"
                            onClick={onAppontmentsClick}
                            value={'Appointments'}
                            />
                        </div>
                        <div>
                            <input
                            className={'nav-items'}
                            type="button"
                            onClick={props}
                            value={ 'Make Reservation'}
                            />
                        </div>
                    </div>
                </div>
            );
        }
        else if(appointmentsClicked){
            // setAppointmentsClicked(false)
            return(
                <Appointments props = {state}/>
            )
            // setAppointmentsClicked(false)
        }
        else if(profileClicked){

        }
        else if(makeReservationClicked){

        }
    }
    else if(state.data == 'Doctor'){
        if(!appointmentsClicked && !profileClicked && !makeReservationClicked){
            return(
                <div>Welcome Doctor!</div>
            )
        }   
    }
    else if(state.data == 'Others'){
        if(!appointmentsClicked && !profileClicked && !makeReservationClicked){
            return(
                <div>Welcome Other!</div>
            )
        }
    }
}