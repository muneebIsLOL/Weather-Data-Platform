import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faBars, faBarsStaggered, faLocationDot, faXmark } from "@fortawesome/free-solid-svg-icons"
import "./App.css"
import Settings from '../settings/Settings'
import { useState } from 'react'

const Navbar = ({ onClick, icon }) => {
    const [animating, setAnimating] = useState(false);

    const handleClick = () => {
        setAnimating(true);

        setTimeout(() => {
            onClick();
            setAnimating(false);
        }, 100);
    };
    return (
        <nav className="nav-bar">
            <p className="icon-wrapper"><FontAwesomeIcon icon={faLocationDot} /><span>Karachi, Pakistan</span></p>
            <div className="icon-wrapper" onClick={handleClick}>
                <FontAwesomeIcon
                    icon={icon ? faXmark : faBarsStaggered}
                    className={`ham-icon icon ${animating ? "fade-out" : "fade-in"}`}
                />
            </div>
        </nav>
    )
}

export default Navbar;