﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
		
	Если Вопрос("После старта процесса согласования, изменения утверждаемого бюджета, станут невозможны. Уверены что хотите стартовать бизнес процесс?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		ТекФормаБП = ПолучитьФорму("БизнесПроцесс.УтверждениеБюджета.Форма.ФормаНовый");
		ТекФормаБП.Объект.Автор = БюджетныйНаСервере.ПолучитьПользователя();
		ТекФормаБП.Объект.Описание = БюджетныйНаСервере.ВернутьРеквизит(ПараметрКоманды, "Комментарий");
		ТекФормаБП.Объект.Заявка = ПараметрКоманды;
		ТекФормаБП.ВладелецФормы = ПараметрыВыполненияКоманды.Источник;
		ТекФормаБП.Объект.ОснованиеЗаблокирован = Истина;
		
		ДанныеФормы = ТекФормаБП.Объект;
		СоздатьБПИнтерактивно1(ДанныеФормы, ПараметрКоманды);
		КопироватьДанныеФормы(ДанныеФормы, ТекФормаБП.Объект);
		ТекФормаБП.Открыть();
	КонецЕсли;
	
	
КонецПроцедуры


&НаСервере
Функция СоздатьБПИнтерактивно1(НовыйБП, ПараметрКоманды)
	
	НовыйБП.Автор = ПараметрыСеанса.ТекущийПользователь;
	НовыйБП.Описание = ПараметрКоманды.Комментарий;
	НовыйБП.Дата = ТекущаяДата();
	НовыйБП.Заявка = ПараметрКоманды;
	НовыйБП.Предприятие = ПараметрКоманды.Предприятие;
	//НовыйБП.ТипБюджета = Перечисления.Д_ТипыБюджетов[ТипБюджета];
	
	
КонецФункции
