import PropTypes from 'prop-types'
import Icon from '../../../shared/components/icon'

function MenuButton({ onClick }) {
  return (
    <div className="toolbar-item">
      <button className="btn btn-full-height" onClick={onClick} title="Menu">
        <Icon type="bars" fw className="" />
      </button>
    </div>
  )
}

MenuButton.propTypes = {
  onClick: PropTypes.func.isRequired,
}

export default MenuButton
