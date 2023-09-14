import Icon from '../../../shared/components/icon'
import * as eventTracking from '../../../infrastructure/event-tracking'

function BackToBaryonBibButton() {
  return (
    <div className="toolbar-item">
      <a
        className="btn btn-full-height"
        draggable="false"
        href="https://www.baryonbib.org/writing"
        title="BaryonBib Writing"
        onClick={() => {
          eventTracking.sendMB('navigation-clicked-home')
        }}
      >
        <Icon type="arrow-left" fw />
      </a>
    </div>
  )
}

export default BackToBaryonBibButton
