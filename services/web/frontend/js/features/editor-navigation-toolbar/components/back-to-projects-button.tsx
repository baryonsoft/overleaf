import { useTranslation } from 'react-i18next'
import Icon from '../../../shared/components/icon'
import * as eventTracking from '../../../infrastructure/event-tracking'

function BackToProjectsButton() {
  const { t } = useTranslation()

  return (
    <div className="toolbar-item">
      <a
        className="btn btn-full-height"
        href="/project"
        title="All Projects"
        onClick={() => {
          eventTracking.sendMB('navigation-clicked-projects')
        }}
      >
        <Icon
          type="arrow-left"
          fw
          accessibilityLabel={t('back_to_your_projects')}
        />
      </a>
    </div>
  )
}

export default BackToProjectsButton
