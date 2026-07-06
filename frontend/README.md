# Frontend

# Description
The front end (or client-side) is the visible part of a website or application that users see and interact with directly. In this frontend, data that is collected from the `fastapi`'s API is displayed in the shape of letters, charts, and numbers. It includes features, such as themes, navbar, and responsive web design (RWD). Libraries such as `React` with `Vite`, `Recharts`, `Font-Awesome`, are used to power the frontend and enhance development, and UX.

# Implementation Details
Following are the implementation details:
## Dynamic Backgrounds
This functionality improves UX by adjusting backgrounds dynamically depending on the weather, such as sunny background for sunny conditions. 

### Key Points
- All the background files are saved in public/.
- They are different for such layouts
  - `desktop`: For layouts bigger than 768px horizontally. 
  - `mobile`: For layouts smaller than 768px horizontally. 
  - `shared`: For both layouts.
- Different images for both night, and day.

## Components
It includes the following components:

## Card
Card is used to display current, hourly, and daily conditions just like a typical weather platform. It's collapsable card designed with responsive web design (RWD) in mind.

### Key Features
- Display's conditions and weather interactively.
- Adjustable units such as Metic, and Imperial.
- Display's temperature chart using `recharts` library.
- Enclose each component in one `<Card/>` component and export that to main body.

## Navbar & Settings
Navbar and Settings are two different components in this application but, they are part of one philosphy and `RWD`. Following are the details:

### Key Details
- Navbar (right now) displays the location, would in future display time, date and more things. Making it more feature-rich.
- Settings component include preferences such as theme, and metrics, and would include more features similar to navbar. Following are the details about settings:
- `Theme`
  - Light
  - Dark
  - Auto (Device Default)
- `Units`
  - Metric (°C • km/h)
  - Imperial (°F • mph)

## Docker
Frontend `Dockerfile` completely packs the frontend module with node and is used as an image in `docker-compose`. Following are the points:

### Key Points
- Copies frontend files such as .jsx and .css files along with components and structure.
- Copies images, backgrounds, and icons.
- Preserve the structure for imports and exports across both local host and containers.
- Deploys the frontend on `0.0.0.0` host with standard port `5173`.
- ignore files such as `node_modules` and other package-config related files in `.dockerignore`.
