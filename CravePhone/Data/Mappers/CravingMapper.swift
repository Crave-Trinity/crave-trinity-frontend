//
//  CravingMapper.swift
//  CravePhone
//
//  Maps new fields (location, people, trigger) in both directions.
//
internal struct CravingMapper {
    
    func mapToEntity(_ dto: CravingDTO) -> CravingEntity {
        CravingEntity(
            id: dto.id,
            cravingDescription: dto.text,
            cravingStrength: dto.cravingStrength,
            confidenceToResist: dto.confidenceToResist,
            emotions: dto.emotions,
            timestamp: dto.timestamp,
            isArchived: dto.isArchived,
            location: dto.location,
            people: dto.people,
            trigger: dto.trigger
        )
    }
    
    func mapToDTO(_ entity: CravingEntity) -> CravingDTO {
        CravingDTO(
            id: entity.id,
            text: entity.cravingDescription,
            confidenceToResist: entity.confidenceToResist,
            cravingStrength: entity.cravingStrength,
            timestamp: entity.timestamp,
            isArchived: entity.isArchived,
            emotions: entity.emotions,
            location: entity.location,
            people: entity.people,
            trigger: entity.trigger
        )
    }
}
