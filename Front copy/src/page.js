export function Page ({ props }) {
    const state = props
    console.log(state)
    return(
        <div>Welcome {state.username}!</div>
    );
}