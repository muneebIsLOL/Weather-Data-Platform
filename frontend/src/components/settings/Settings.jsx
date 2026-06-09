import { faCog } from "@fortawesome/free-solid-svg-icons";
import "./App.css"
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { useState } from "react";
import { useTheme } from "../../hooks/theme"
import capitalizeFirstLetter from "../../utils/text"



const Settings = ({ className, unit, setUnits }) => {
    const [openItem, setOpenItem] = useState(null);
    const { themeMode, setThemeMode } = useTheme();
    const toggleItem = (index) => {
        setOpenItem(current =>
            current === index ? null : index
        );
    };

    const UNIT_MAP = {
            metric: {
                temp: "C",
                speed: "km/h",
                text: "Metric: °C • km/h"
            },
    
            imperial: {
                temp: "F",
                speed: "mph",
                text: "Imperial: °F • mph"
            }
    }

    return (
        <div className={`settings-wrapper ${className}`}>
            <div className="settings">
                <h1 className="icon-wrapper"><FontAwesomeIcon icon={faCog} className="settings-icon icon" />Settings</h1>
                <div className="container">
                    <div className="item">
                        <div
                            className={`dropdown-toggle ${openItem === 1 ? "show" : "hide"}`}
                            onClick={() => toggleItem(1)}
                        >
                            <h2>Units</h2>
                            <span>{UNIT_MAP[unit]["text"]}</span>
                        </div>

                        <div className={`dropdown ${openItem === 1 ? "open" : ""}`}>
                            <p onClick={() => setUnits("metric")} className={`${unit == "metric" ? "active" : ""}`}>{UNIT_MAP["metric"]["text"]}</p>
                            <p onClick={() => setUnits("imperial")} className={`${unit == "imperial" ? "active" : ""}`}>{UNIT_MAP["imperial"]["text"]}</p>
                        </div>
                    </div>

                    <div className="item">
                        <div
                            className={`dropdown-toggle ${openItem === 2 ? "show" : "hide"}`}
                            onClick={() => toggleItem(2)}
                        >
                            <h2>Theme</h2>
                            <span>{capitalizeFirstLetter(themeMode)}</span>
                        </div>

                        <div className={`dropdown ${openItem === 2 ? "open" : ""}`}>
                            <p
                                onClick={() => setThemeMode("system")}
                                className={themeMode === "system" ? "active" : ""}
                            >
                                Automatic (System)
                            </p>

                            <p
                                onClick={() => setThemeMode("dark")}
                                className={themeMode === "dark" ? "active" : ""}
                            >
                                Dark
                            </p>

                            <p
                                onClick={() => setThemeMode("light")}
                                className={themeMode === "light" ? "active" : ""}
                            >
                                Light
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}


export default Settings;